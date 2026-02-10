# Use official Flutter image with Dart SDK 3.5+ (compatible with project)
FROM ghcr.io/cirruslabs/flutter:3.24.5 AS build

WORKDIR /app

# Copy the Flutter project from the voxlyce_front subdirectory
COPY voxlyce_front/ .

# Get dependencies and build for web
RUN flutter pub get
RUN flutter build web --release

# Production stage with nginx
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

