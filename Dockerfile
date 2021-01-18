#Base Image
FROM ghcr.io/arghyac35/test:master

WORKDIR /app/

CMD ["bash", "start.sh"]
