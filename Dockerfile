FROM ghcr.io/home-assistant/base:latest

RUN apk add --no-cache python3 py3-pip jq

COPY immich_face_to_album /opt/immich_face_to_album/immich_face_to_album
COPY requirements.txt /opt/immich_face_to_album/requirements.txt

RUN pip install --no-cache-dir --break-system-packages -r /opt/immich_face_to_album/requirements.txt

ENV PYTHONPATH="/opt/immich_face_to_album"

COPY run.sh /
RUN chmod a+x /run.sh

ARG BUILD_VERSION
ARG BUILD_ARCH
LABEL \
  io.hass.version="${BUILD_VERSION}" \
  io.hass.type="addon" \
  io.hass.arch="${BUILD_ARCH}"

CMD [ "/run.sh" ]
