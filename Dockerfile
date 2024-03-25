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
    CI=true \
    DOTNET_VERSION=8.0

# Install .NET CLI dependencies
# https://github.com/dotnet/runtime/blob/main/src/installer/pkg/sfx/installers/dotnet-runtime-deps/dotnet-runtime-deps-debian.proj
RUN echo "Starting Dependency Install" \
    && apt-get update \
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
    && apt-get install -y powershell \
    && rm -rf /var/lib/apt/lists/* \
    && ln -fs /usr/share/zoneinfo/Australia/Perth /etc/localtime \
    && dpkg-reconfigure tzdata

RUN echo "Starting Dotnet Install" \
    && dotnet_version=$DOTNET_VERSION \
    && echo "Downloading Dotnet Core: $dotnet_version" \
    && case $dotnet_version in \
        6.0) dotnet_version_dl="6.0.420";; \
        7.0) dotnet_version_dl="7.0.407";; \
        8.0) dotnet_version_dl="8.0.203";; \
        *) \
            echo "Unknown dotnet version: $dotnet_version" \
            return 1 \
            ;; \
        esac \
    && echo "Matched DotNet Version $dotnet_version to $dotnet_version_dl" \
    && curl -fSL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$dotnet_version_dl/dotnet-sdk-$dotnet_version_dl-linux-x64.tar.gz \
    && echo "Download Complete. Extracting..." \
    && mkdir -p /usr/share/dotnet \
    && tar -oxzf dotnet.tar.gz -C /usr/share/dotnet \
    && echo "Extraction Complete. Configuring..." \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && dotnet help \
    && echo "Installing Additional DotNet Tools" \
    && dotnet tool install --global dotnet-format \
    && dotnet tool install --global dotnet-svcutil --version 2.2.0-preview1.23462.5 \
    && if [ "$dotnet_version" = "8.0" ]; then \
        echo "Installing dotnet-ef for DotNet 8.0" \
        && dotnet tool install --global dotnet-ef; \
        echo "Installing Additional DotNet Workloads for DotNet 8.0" \
        && dotnet workload install aspire; \
       fi \
    && echo "Install Complete"
