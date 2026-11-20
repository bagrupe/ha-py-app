FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine

WORKDIR /app

ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

# Set time and date to CET
RUN apk add --no-cache tzdata

ENV TZ=Europe/Berlin

COPY ./out .
ENTRYPOINT ["dotnet", "API.dll"]
