FROM ubuntu:latest

ENV \
    # Do not generate certificate
    DOTNET_GENERATE_ASPNET_CERTIFICATE=false \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # Configure web servers to bind to port 80 when present
    ASPNETCORE_URLS=http://+:80 \
    # Do not show first run text
    DOTNET_NOLOGO=true \
    DEBIAN_FRONTEND=noninteractive \
    CI=true

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu70 \
        libssl3 \
        libstdc++6 \
        zlib1g \
        tzdata \
        jq \
        zip \
        curl \
        wget \
        git \
        apt-transport-https \
        software-properties-common \
    && VERSION_ID=$(grep VERSION_ID /etc/os-release | cut -d '"' -f 2) \
    && wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y powershell dotnet-sdk-8.0 \
    && rm -rf /var/lib/apt/lists/* \
    && ln -fs /usr/share/zoneinfo/Australia/Perth /etc/localtime \
    && dpkg-reconfigure tzdata \
    && dotnet tool install --global dotnet-ef \
    && dotnet tool install --global GitVersion.Tool \
    && dotnet workload install aspire
