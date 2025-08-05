# RMW-Zenoh router docker

This is a docker for a ROS2 Zenoh-RMW router. The router is installed using `apt`.

## Build

From this project directory call:

```sh
docker image build --rm -t rmw_zenoh_router:jazzy $PWD
```

## Start manually

```sh
docker run --init --rm --user ubuntu \
  --network=host -v $PWD:/rmw_zenoh_router \
  rmw_zenoh_router:jazzy
```

## Install as `systemd` service

Edit `rmw_zenoh_router.service` file, set path to this directory in the ExecStart line (just after the `-v`). Then:

```sh
sudo cp -v rmw_zenoh_router.service /etc/systemd/system
sudo systemctl enable rmw_zenoh_router.service
sudo systemctl start rmw_zenoh_router.service
```

Verify it is working:

```sh
sudo systemctl status rmw_zenoh_router.service
sudo journalctl -f -u rmw_zenoh_router.service
```

To uninstall:

```sh
sudo systemctl stop rmw_zenoh_router.service
sudo systemctl disable rmw_zenoh_router.service
sudo systemctl daemon-reload
```

## TODO

* Make the zenohd die (gracefully) when doing ^C-ing on a manually started docker.

## Who

Jorge, <jvisca@fing.edu.uy>
