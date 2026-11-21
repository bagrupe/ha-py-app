FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build

WORKDIR /src

ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

COPY global.json ./
COPY API/API.csproj API/
ARG NuGetAudit=true
RUN dotnet restore API/API.csproj

COPY . .
ARG CI_COMMIT_REF_SLUG=local
ARG SENTRY_ENVIRONMENT=local
RUN dotnet publish API/API.csproj -c Release -o /publish --no-restore \
    -p:InformationalVersion="$CI_COMMIT_REF_SLUG" -p:Description="$SENTRY_ENVIRONMENT"

FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine

WORKDIR /app

ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

# Set time and date to CET
RUN apk add --no-cache tzdata

ENV TZ=Europe/Berlin

COPY --from=build /publish .
ENTRYPOINT ["dotnet", "API.dll"]
