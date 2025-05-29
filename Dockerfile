# Step 1: Use an official Caddy image.
FROM caddy:2-alpine

# Step 2: Copy your Caddyfile (now configured for port 8080)
COPY Caddyfile /etc/caddy/Caddyfile

# Step 3: Copy your HTML file
COPY src/html/unit-converter.html /usr/share/caddy/unit-converter.html

# Step 4: Expose the new non-privileged port Caddy will listen on
EXPOSE 8080
