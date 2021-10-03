FROM mcr.microsoft.com/dotnet/core/aspnet:3.1.17-buster-slim-arm32v7

ARG FILE_LOCATION="https://ispyfiles.azureedge.net/downloads/Agent_ARM32_3_4_3_0.zip"
ENV FILE_LOCATION_SET=${FILE_LOCATION:+true}
ENV DEFAULT_FILE_LOCATION="https://www.ispyconnect.com/api/Agent/DownloadLocation2?productID=24&is64=true&platform=Linux"
ARG DEBIAN_FRONTEND=noninteractive 
ARG TZ=America/Los_Angeles

RUN apt-get update \
    && apt-get install -y wget libtbb-dev libc6-dev unzip multiarch-support gss-ntlmssp software-properties-common libatlas-base-dev gpg ffmpeg \
    && wget http://ports.ubuntu.com/pool/main/libj/libjpeg-turbo/libjpeg-turbo8_1.5.2-0ubuntu5.18.04.4_armhf.deb \
    && wget http://ports.ubuntu.com/pool/main/libj/libjpeg8-empty/libjpeg8_8c-2ubuntu8_armhf.deb \
    && dpkg -i libjpeg-turbo8_1.5.2-0ubuntu5.18.04.4_armhf.deb \
    && dpkg -i libjpeg8_8c-2ubuntu8_armhf.deb \
    && rm libjpeg8_8c-2ubuntu8_armhf.deb \
    && rm libjpeg-turbo8_1.5.2-0ubuntu5.18.04.4_armhf.deb

RUN if [ "${FILE_LOCATION_SET}" = "true" ]; then \
    echo "Downloading from specific location: ${FILE_LOCATION}" && \
    wget -c ${FILE_LOCATION} -O agent.zip; \
    else \
    echo "Downloading latest" && \
    wget -c $(wget -qO- "https://www.ispyconnect.com/api/Agent/DownloadLocation2?productID=24&is64=true&platform=Linux" | tr -d '"') -O agent.zip; \
    fi && \
    unzip agent.zip -d /agent && \
    rm agent.zip

RUN apt-get install -y libgdiplus

RUN apt-get install -y tzdata

RUN apt-get -y --purge remove unzip wget \ 
    && apt autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

EXPOSE 8090

EXPOSE 3478/udp

EXPOSE 50000-50010/udp

VOLUME ["/agent/Media/XML", "/agent/Media/WebServerRoot/Media", "/agent/Commands"]

CMD ["dotnet", "/agent/Agent.dll"]

