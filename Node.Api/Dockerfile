#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Node.Api/Node.Api.csproj", "Node.Api/"]
RUN dotnet restore "Node.Api/Node.Api.csproj"
COPY . .
WORKDIR "/src/Node.Api"
RUN dotnet build "Node.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Node.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Node.Api.dll"]