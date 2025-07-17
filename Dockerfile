ARG ROS_DISTRO=jazzy
FROM ros:${ROS_DISTRO}-ros-core

# Add ubuntu user with same UID and GID as your host system, if it doesn't already exist
# Since Ubuntu 24.04, a non-root user is created by default with the name vscode and UID=1000
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN if ! id -u $USER_UID >/dev/null 2>&1; then \
        groupadd --gid $USER_GID $USERNAME && \
        useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME; \
    fi
# Add sudo support for the non-root user
RUN apt-get update && \
    apt-get install -y sudo && \
    echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    echo "Defaults env_keep = \"http_proxy ftp_proxy\"" >> /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Switch from root to user
USER $USERNAME

# Upgrade and Install rmw-zenoh-cpp
RUN sudo apt update \
    && sudo apt upgrade -y \
    && sudo apt install -y \
    ros-${ROS_DISTRO}-rmw-zenoh-cpp \
    && sudo rm -rf /var/lib/apt/lists/*

WORKDIR /rmw_zenoh_router

ENV ZENOH_ROUTER_CONFIG_URI=/rmw_zenoh_router/zenoh_router_config.json5
ENV ZENOH_SESSION_CONFIG_URI=/rmw_zenoh_router/zenoh_session_config.json5
ENV RMW_IMPLEMENTATION=rmw_zenoh_cpp
ENV RUST_LOG=zenoh=info,zenoh_transport=debug

# Expose the Zenoh router port (optional)
EXPOSE 7447/udp
EXPOSE 7447/tcp

# Copy the zenoh_start.sh into the image and adjust permissions
COPY zenoh_start.sh /zenoh_start.sh
RUN sudo chmod +x /zenoh_start.sh

ENTRYPOINT [ "/zenoh_start.sh" ]

