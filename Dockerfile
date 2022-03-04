#Base Image

FROM ghcr.io/k-e-n-w-a-y/aria-telegram-mirror-bot:main


WORKDIR /bot/

CMD ["bash", "start.sh"]
