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
  io.hass.version="1.0.0" \
  io.hass.type="addon" \
  io.hass.arch="armhf|aarch64|amd64|armv7|i386"

CMD [ "/run.sh" ]
