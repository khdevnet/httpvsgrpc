FROM mcr.microsoft.com/devcontainers/base:jammy
COPY ./.devcontainer/installdotnet.sh ./
    
RUN ./installdotnet.sh dotnet-sdk-7.0

RUN apt-get update \
    && apt-get -y install git
