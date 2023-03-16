FROM mcr.microsoft.com/devcontainers/base:jammy
RUN apt-get update \
    && apt-get -y install git \
    && apt-get install -y dotnet-sdk-6.0

RUN git clone https://github.com/khdevnet/oauth.git
