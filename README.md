# Ubuntu Desktop running Openbox in VNC for Rapid Developers

## Base Docker Image
[fullaxx/ubuntu-desktop](https://hub.docker.com/r/tghastings/ubuntu-desktop)

## VNC Options
Optional: Set Depth 16 \
Default: 24
```
-e VNCDEPTH='16'
```
Optional: Set 1920x1080 Resolution \
Default: 1280x800
```
-e VNCRES='1920x1080'
```
Optional: Bind to Port 5909 \
Default: port 5901
```
-e VNCPORT='9'
```
Optional: Set Password Authentication \
Default: No Authentication
```
-e VNCPASS='vncpass'
```
Optional: Set Read-Write and Read-Only password \
Default: No Authentication
```
-e VNCPASS='vncpass' -e VNCPASSRO='readonly'
```
Optional: Run as a non-root user \
Default: root (UID: 0)
```
-e VNCUSER='guest' -e VNCUID='1000'
```
Optional: Set a custom group for non-root user \
Default: same as VNCUSER and VNCUID
```
-e VNCGROUP='guests' -e VNCGID='1001'
```
Optional: Set umask to define permission for new files \
Default: 0022
```
-e VNCUMASK='0002'
```

## TimeZone Configuration
Set the timezone to be used inside the container \
Default: UTC
```
-e TZ='Asia/Tokyo'
-e TZ='Europe/London'
-e TZ='America/Los_Angeles'
-e TZ='America/Denver'
-e TZ='America/Chicago'
-e TZ='America/New_York'
```

## FUSE Configuration (to support AppImages)
Set privileges to allow FUSE to work properly inside the container
```
--device /dev/fuse --cap-add SYS_ADMIN
```

## Shared Memory Modification (to support Web Browsers)
Increase the size of shared memory to prevent web browsers from crashing \
Thanks to [jlesage](https://hub.docker.com/r/jlesage/firefox/#increasing-shared-memory-size)
```
--shm-size 2g
```

## Run the image
Run the image on localhost port 5901 with default configuration
```
docker run -d -p 127.0.0.1:5901:5901 tghastings/ubuntu-rapid-dev
```
Run the image with Depth 16
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCDEPTH='16' tghastings/ubuntu-rapid-dev
```
Run the image with 1920x1080 Resolution
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCRES='1920x1080' tghastings/ubuntu-rapid-dev
```
Run the image with Password Authentication
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCPASS='vncpass' tghastings/ubuntu-rapid-dev
```
Run the image with Read-Write and Read-Only password (Using R/O pass requires R/W pass)
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCPASS='vncpass' -e VNCPASSRO='readonly' tghastings/ubuntu-rapid-dev
```
Run the image as a non-root user account
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCUSER='guest' -e VNCUID='1000' tghastings/ubuntu-rapid-dev
```
Run the image as a non-root user account with custom group
```
docker run -d -p 127.0.0.1:5901:5901 -e VNCUSER='guest' -e VNCUID='1000' -e VNCGROUP='guests' -e VNCGID='1001' tghastings/ubuntu-rapid-dev
```
Run the image in Tokyo
```
docker run -d -p 127.0.0.1:5901:5901 -e TZ='Asia/Tokyo' tghastings/ubuntu-rapid-dev
```
Run the image with FUSE privileges
```
docker run --device /dev/fuse --cap-add SYS_ADMIN -d -p 127.0.0.1:5901:5901 tghastings/ubuntu-rapid-dev
```
Run the image using host networking binding tigervncserver to port 5909
```
docker run -d --network=host -e VNCPORT='9' tghastings/ubuntu-rapid-dev
```
Run the image on localhost port 5901 with a decent hostname
```
docker run -d -h mycagedbuntu -p 127.0.0.1:5901:5901 tghastings/ubuntu-rapid-dev
```

## Using Jupyter Notebook
Run the image exposing port 8888 for jupyter notebook
```
docker run -d -h jupyternotebook -p 5901:5901 -p 8888:8888 tghastings/ubuntu-rapid-dev
```

## Connect using vncviewer
```
vncviewer 127.0.0.1:5901
```

## Build it locally using the github repository
```
docker build -t="tghastings/ubuntu-rapid-dev" github.com/tghastings/ubuntu-rapid-dev
```
