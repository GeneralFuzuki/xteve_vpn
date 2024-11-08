FROM alpine:latest
RUN apk update
RUN apk upgrade
RUN apk add --no-cache ca-certificates openvpn runit tzdata bash busybox-suid su-exec

MAINTAINER GeneralFuzuki genfuzuki@outlook.com

# Timezone (TZ)
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# OpenVPN Variables
ENV OPENVPN_FILE=Frankfurt.ovpn \
LOCAL_NET=192.168.1.0/24

# Volumes
VOLUME /config

# Add ffmpeg and vlc
RUN apk add ffmpeg
RUN apk add vlc
RUN sed -i 's/geteuid/getppid/' /usr/bin/vlc

# Add Files
COPY Frankfurt.ovpn /
COPY logindata.conf /
COPY startups /startups

# Add xTeve and guide2go
RUN wget https://github.com/SenexCrenshaw/xTeVe/releases/download/v2.5.3/xteve-v2.5.3-linux-amd64.tar.gz tar -xf xteve-v2.5.3-linux-amd64.tar.gz -C /usr/bin
RUN chmod +x /usr/bin/xteve

RUN find /startups -name run | xargs chmod u+x

# Add Expose Port
EXPOSE 8080
EXPOSE 34400

# Command
CMD ["runsvdir", "/startups"]
