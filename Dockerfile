#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["testapp3/testapp3.csproj", "testapp3/"]
RUN dotnet restore "testapp3/testapp3.csproj"
COPY . .
WORKDIR "/src/testapp3"
RUN dotnet build "testapp3.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "testapp3.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "testapp3.dll"]