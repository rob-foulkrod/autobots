FROM mcr.microsoft.com/dotnet/sdk:6.0 as build
WORKDIR /app
COPY autobots.web.csproj .
RUN dotnet restore

COPY . .

RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:6.0

WORKDIR /app
COPY --from=build /app/out .

EXPOSE 80
ENTRYPOINT ["dotnet", "autobots.web.dll"]