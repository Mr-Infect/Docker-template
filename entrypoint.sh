#!/bin/bash

# Inject public key if provided
if [ ! -z "$SSH_PUBLIC_KEY" ]; then
    echo "$SSH_PUBLIC_KEY" > /home/ghost/.ssh/authorized_keys
    chown ghost:ghost /home/ghost/.ssh/authorized_keys
    chmod 600 /home/ghost/.ssh/authorized_keys
    echo "✅ SSH public key added for ghost"
fi

# Enable Apache if specified
if [ "$APACHE_ENABLE" = "true" ]; then
    service apache2 start
    echo "🌐 Apache2 started"
fi

# Optional: start nginx (comment if not needed)
# service nginx start

exec "$@"
