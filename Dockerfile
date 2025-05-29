# Step 1: Use an official Caddy image.
# 'caddy:2-alpine' is a good choice as it's lightweight.
FROM caddy:2-alpine

# Step 2: Copy your Caddyfile from your repository into the Caddy configuration directory in the image.
# Caddy automatically looks for /etc/caddy/Caddyfile.
COPY Caddyfile /etc/caddy/Caddyfile

# Step 3: Copy your HTML file from its location in your repository (src/html/unit-converter.html)
# to the directory Caddy is configured to serve from (as defined by 'root * /usr/share/caddy' in your Caddyfile).
COPY src/html/unit-converter.html /usr/share/caddy/unit-converter.html

# Step 4: Expose the port Caddy listens on.
# Our Caddyfile is set up for port 80.
EXPOSE 80

# The default command for the caddy image is `caddy run --config /etc/caddy/Caddyfile`.
# We don't need to override it unless we have more advanced needs.
