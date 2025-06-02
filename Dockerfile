# Step 1: Use an official Caddy image.
FROM caddy:2.8.4-alpine
RUN apk add --no-cache ca-certificates
RUN apk add --no-cache curl

# solving exec /usr/bin/caddy: operation not permitted
RUN adduser -D caddy

RUN chmod g+rwx /usr/bin/caddy /srv /etc/caddy/ /config/caddy/ && \
    chgrp -R root /usr/bin/caddy && \
    addgroup caddy root


# Step 2: Copy your Caddyfile (configured for port 8080)
COPY Caddyfile /etc/caddy/Caddyfile

# Step 3: Copy your HTML file
COPY frontend/src/html/unit-converter.html /usr/share/caddy/unit-converter.html

RUN caddy fmt --overwrite /etc/caddy/Caddyfile
RUN caddy validate -c /etc/caddy/Caddyfile

EXPOSE 8080
