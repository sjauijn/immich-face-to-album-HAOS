ARG BUILD_FROM
FROM ${BUILD_FROM}

RUN apk add --no-cache python3 py3-pip jq

COPY immich_face_to_album /opt/immich_face_to_album/immich_face_to_album
COPY requirements.txt /opt/immich_face_to_album/requirements.txt

RUN pip install --no-cache-dir --break-system-packages -r /opt/immich_face_to_album/requirements.txt

ENV PYTHONPATH="/opt/immich_face_to_album"

COPY run.sh /
RUN chmod a+x /run.sh

LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="sjauijn" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="sjauijn" \
    org.opencontainers.image.authors="sjauijn" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/sjauijn/immich-face-to-album-HAOS" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

CMD [ "/run.sh" ]
