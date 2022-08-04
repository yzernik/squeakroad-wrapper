#!/bin/bash
set -e

SQUEAKROAD_PASS=$(yq e '.password' /root/start9/config.yaml)

export ROCKET_PORT=8080
export ROCKET_ADDRESS=0.0.0.0
export SQUEAKROAD_DB_URL=/root/db.sqlite
export SQUEAKROAD_ADMIN_USERNAME=squeakroad-admin
export SQUEAKROAD_ADMIN_PASSWORD=${APP_PASSWORD}
export SQUEAKROAD_LND_HOST=lnd.embassy
export SQUEAKROAD_LND_PORT=10009
export SQUEAKROAD_LND_TLS_CERT_PATH=/mnt/lnd/tls.cert
export SQUEAKROAD_LND_MACAROON_PATH=/mnt/lnd/data/chain/bitcoin/mainnet/admin.macaroon

# Generate a secret
export ROCKET_SECRET_KEY=$(openssl rand -base64 32)

# Properties Page showing password to be used for login
  echo 'version: 2' >> /root/start9/stats.yaml
  echo 'data:' >> /root/start9/stats.yaml
  echo '  Username: ' >> /root/start9/stats.yaml
        echo '    type: string' >> /root/start9/stats.yaml
        echo '    value: squeakroad-admin' >> /root/start9/stats.yaml
        echo '    description: This is your admin username for Squeak Road' >> /root/start9/stats.yaml
        echo '    copyable: true' >> /root/start9/stats.yaml
        echo '    masked: false' >> /root/start9/stats.yaml
        echo '    qr: false' >> /root/start9/stats.yaml
  echo '  Password: ' >> /root/start9/stats.yaml
        echo '    type: string' >> /root/start9/stats.yaml
        echo "    value: \"$SQUEAKROAD_PASS\"" >> /root/start9/stats.yaml
        echo '    description: This is your admin password for Squeak Road. Please use caution when sharing this password, you could lose your funds!' >> /root/start9/stats.yaml
        echo '    copyable: true' >> /root/start9/stats.yaml
        echo '    masked: true' >> /root/start9/stats.yaml
        echo '    qr: false' >> /root/start9/stats.yaml

# Starting squeakroad process
echo "Starting squeakroad ..."
exec tini -p SIGTERM -- squeakroad
