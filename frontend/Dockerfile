# Dockerfile for our Flutter web app.
# Build stage
FROM cirrusci/flutter:stable as build

# set working directory
WORKDIR /app

COPY . ./
RUN flutter pub get
RUN flutter gen-l10n
RUN flutter build web

# -------------------------
## Uncomment to run a dev version:
# EXPOSE 3000
# CMD ["npm", "start"]
# -------------------------

## Production server stage
## Comment out to run a dev version:
FROM nginx:1-alpine

COPY --from=build /app/build/web /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]