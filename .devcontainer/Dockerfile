FROM mcr.microsoft.com/devcontainers/base:jammy
    
RUN curl -s https://raw.githubusercontent.com/khdevnet/wsl2-env/main/install-dotnet7.sh | bash

RUN curl -s https://raw.githubusercontent.com/khdevnet/wsl2-env/main/install-git.sh | sh
RUN git config --global --add safe.directory /workspaces/httpvsgrpc
