#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["blazor-car-app/blazor-car-app.csproj", "blazor-car-app/"]
RUN dotnet restore "blazor-car-app/blazor-car-app.csproj"
COPY . .
WORKDIR "/src/blazor-car-app"
RUN dotnet build "blazor-car-app.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "blazor-car-app.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "blazor-car-app.dll"]