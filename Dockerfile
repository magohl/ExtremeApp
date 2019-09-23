FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["ExtremeApp.csproj", "./"]
RUN dotnet restore "./ExtremeApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ExtremeApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ExtremeApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ExtremeApp.dll"]
