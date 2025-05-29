# Step 1: Use an official Caddy image.
FROM caddy:2-alpine

# Step 2: Copy your Caddyfile (configured for port 8080)
COPY Caddyfile /etc/caddy/Caddyfile

# Step 3: Copy your HTML file
COPY src/html/unit-converter.html /usr/share/caddy/unit-converter.html

# --- OpenShift Permission Adjustments ---
USER root # Switch to root temporarily to change ownership and permissions.

# Caddy's default data dir is /data, config dir is /config.
# Caddy's default workdir is /srv.
# Caddy's config file is in /etc/caddy.
# We need to ensure these are usable by OpenShift's arbitrary UID (which is in GID 0).
RUN mkdir -p /data/caddy /config/caddy && \
    chgrp -R 0 /data /config /etc/caddy /srv && \
    chmod -R g+rX /data /config /etc/caddy /srv && \ # Group read + execute(for dirs)
    chmod -R g+w /data /config /srv && \ # Add group write for dirs Caddy might write to
    # Ensure the Caddyfile itself is group-readable
    chmod g+r /etc/caddy/Caddyfile && \
    # Ensure the directory Caddy serves from is readable by all.
    chmod -R o+r /usr/share/caddy && \
    # Ensure the Caddy binary and entrypoint are executable by "others" (which covers the arbitrary UID).
    # The base image usually has this, but an explicit o+x is a safeguard.
    chmod o+x /usr/bin/caddy /usr/bin/docker-entrypoint.sh

# Revert to the 'caddy' user. OpenShift will likely override the UID portion
# but will respect the GID 0 (root) for group permissions set above.
USER caddy
# --- End OpenShift Permission Adjustments ---

EXPOSE 8080
