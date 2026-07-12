FROM postgres:16-alpine

COPY docker-entrypoint-init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint-init.sh

ENTRYPOINT ["docker-entrypoint-init.sh"]
CMD ["postgres"]
