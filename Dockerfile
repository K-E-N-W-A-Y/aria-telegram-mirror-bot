#Base Image
FROM ghcr.io/k-e-n-w-a-y/aria-telegram-mirror-bot:master

WORKDIR /bot/

CMD ["bash", "start.sh"]
