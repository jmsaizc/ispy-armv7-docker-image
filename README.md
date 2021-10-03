# iSpy-armv7-docker-image

**iSpy Dockerfile for armv7 devices like raspberry pi**

iSpy is the world’s most popular open source video surveillance application. It's compatible with the the vast majority of consumer webcams and IP cameras.

## Build image
```
docker build -t ispyagentdvr:armv7 .
```

## Launch container

**Create docker volumes**
```
docker volume create ispyagentdvr-appdata-config && \
docker volume create ispyagentdvr-appdata-media && \
docker volume create ispyagentdvr-appdata-commands
```

**Run container**
```
docker run -d -p 8090:8090 -p 3478:3478/udp -p 50000-50010:50000-50010/udp \
-v ispyagentdvr-appdata-config:/agent/Media/XML/ \ 
-v ispyagentdvr-appdata-media:/agent/Media/WebServerRoot/Media/ \ 
-v ispyagentdvr-appdata-commands:/agent/Commands/ \ 
-e TZ=Europe/Madrid \ 
--name agentdvr ispyagentdvr:armv7
```
## Access iSpy
```
http://<<ipaddr>>:8090/
```
