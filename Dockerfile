# syntax=docker/dockerfile:1
ARG UID=1001

FROM busybox:1 as final

ARG UID

RUN install -d -m 774 -o $UID -g 0 /app && \
    install -d -m 774 -o $UID -g 0 /.mc
WORKDIR /app

COPY --link --from=minio/mc:latest /usr/bin/mc /bin/mc
COPY --link --from=minio/mc:latest /etc/pki/ca-trust/extracted/pem/ /etc/pki/ca-trust/extracted/pem/

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 /bin/dumb-init 
RUN chmod +x /bin/dumb-init

# Copy the bash script into the container
COPY --chown=$UID:0 --chmod=774 \
    s3-uploader.sh .

# Set environment variables
ENV S3_ENDPOINT=""
ENV S3_ACCESS_KEY=""
ENV S3_SECRET_KEY=""
ENV DESTINATION_BUCKET=""
ENV DESTINATION_DIRECTORY=""

USER $UID
VOLUME [ "/sharedvolume" ]

ENTRYPOINT [ "dumb-init", "--", "./s3-uploader.sh" ]