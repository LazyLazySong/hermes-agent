FROM nousresearch/hermes-agent:main

COPY start.sh /usr/local/bin/hermes-railway
COPY 010-railway-env-sync /etc/cont-init.d/010-railway-env-sync
RUN chmod +x /usr/local/bin/hermes-railway /etc/cont-init.d/010-railway-env-sync

CMD ["hermes-railway"]
