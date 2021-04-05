# Base OS layer: Latest Ubuntu LTS + mssql-server-linux (SQL Server engine + tools)
FROM mcr.microsoft.com/mssql/server:2019-latest as base

# Run SQL Server as root
USER root

# Install packages - SQL Full Text and PowerShell
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false update && \
    apt-get update && \
    apt-get install -y curl gnupg  && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2019.list | tee /etc/apt/sources.list.d/mssql-server.list && \
    apt-get update && \
    apt-get install -y mssql-server-fts && \
    apt-get install -y wget apt-transport-https && \
    wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update

FROM base AS final
# Set environment variables
ARG PASSWORD
ARG USERID
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=${PASSWORD}
ENV UserId=${USERID}
ENV Password=${PASSWORD}

# Run SQL server when container is started
CMD /opt/mssql/bin/sqlservr
