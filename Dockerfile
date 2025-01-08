# Use the official .NET SDK image as a base image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

# Set the working directory
WORKDIR /app

# Copy the solution file and project files
# COPY ca_react_sqlite.sln ./
COPY src/Domain/Domain.csproj ./src/Domain/
COPY src/Application/Application.csproj ./src/Application/
COPY src/Infrastructure/Infrastructure.csproj ./src/Infrastructure/
COPY src/Web/Web.csproj ./src/Web/
COPY tests/Application.UnitTests/Application.UnitTests.csproj ./tests/Application.UnitTests/
COPY tests/Domain.UnitTests/Domain.UnitTests.csproj ./tests/Domain.UnitTests/
COPY tests/Web.AcceptanceTests/Web.AcceptanceTests.csproj ./tests/Web.AcceptanceTests/
COPY tests/Application.FunctionalTests/Application.FunctionalTests.csproj ./tests/Application.FunctionalTests/
COPY tests/Infrastructure.IntegrationTests/Infrastructure.IntegrationTests.csproj ./tests/Infrastructure.IntegrationTests/

# Print the contents of the solution directory for debugging
RUN ls -R /app

# Print the contents of each project directory for debugging
RUN ls -R /app/src/Domain
RUN ls -R /app/src/Application
RUN ls -R /app/src/Infrastructure
RUN ls -R /app/src/Web
RUN ls -R /app/tests/Application.UnitTests
RUN ls -R /app/tests/Domain.UnitTests
RUN ls -R /app/tests/Web.AcceptanceTests
RUN ls -R /app/tests/Application.FunctionalTests
RUN ls -R /app/tests/Infrastructure.IntegrationTests

# Restore dependencies
RUN dotnet restore ./src/Web/Web.csproj --verbosity detailed

# Copy the rest of the application files
COPY . ./

# Build the solution
RUN dotnet build -c Release ./src/Web/Web.csproj  --no-restore

# Publish the application
RUN dotnet publish -c Release ./src/Web/Web.csproj  -o out

# Use the official .NET runtime image as a base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Set the working directory
WORKDIR /app

# Copy the published files from the build environment
COPY --from=build-env /app/out .

# Specify the entry point for the Docker container
ENTRYPOINT ["dotnet", "Web.dll"]