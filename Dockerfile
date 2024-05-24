# syntax=docker/dockerfile:1
ARG UID=1001
ARG VERSION=EDGE
ARG RELEASE=0

########################################
# Compress stage
########################################
FROM minio/mc as mc

FROM alpine:3.19 as compress

# RUN mount cache for multi-arch: https://github.com/docker/buildx/issues/549#issuecomment-1788297892
ARG TARGETARCH
ARG TARGETVARIANT

# Compress mc and dumb-init with upx
RUN --mount=type=cache,id=apk-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/var/cache/apk \
    --mount=from=mc,source=/usr/bin/mc,target=/tmp/mc,rw \
    apk update && apk add -u \
    -X "https://dl-cdn.alpinelinux.org/alpine/edge/community" \
    upx dumb-init && \
    cp /tmp/mc / && \
    #! UPX will skip small files and large files
    # https://github.com/upx/upx/blob/5bef96806860382395d9681f3b0c69e0f7e853cf/src/p_unix.cpp#L80
    # https://github.com/upx/upx/blob/b0dc48316516d236664dfc5f1eb5f2de00fc0799/src/conf.h#L134
    upx --best --lzma /mc || true; \
    upx --best --lzma /usr/bin/dumb-init || true; \
    apk del upx

########################################
# Final stage
########################################
FROM busybox:1 as final

ARG UID

# Create directories with correct permissions
RUN install -d -m 775 -o $UID -g 0 /app && \
    install -d -m 775 -o $UID -g 0 /licenses \
    install -d -m 774 -o $UID -g 0 /.mc

# Copy licenses (OpenShift Policy)
COPY --link --chown=$UID:0 --chmod=775 LICENSE /licenses/LICENSE

COPY --link --chown=$UID:0 --chmod=775 --from=compress /mc /usr/bin/dumb-init /usr/bin/
COPY --link --chown=$UID:0 --chmod=775 --from=mc /etc/pki/ca-trust/extracted/pem/ /etc/pki/ca-trust/extracted/pem/

# Copy the bash script into the container
COPY --link --chown=$UID:0 --chmod=775 s3-uploader.sh /app/

# Set environment variables
ENV S3_ENDPOINT=""
ENV S3_ACCESS_KEY=""
ENV S3_SECRET_KEY=""
ENV DESTINATION_BUCKET=""
ENV DESTINATION_DIRECTORY=""

WORKDIR /app

VOLUME [ "/sharedvolume" ]

USER $UID

STOPSIGNAL SIGINT

ENTRYPOINT [ "dumb-init", "--", "./s3-uploader.sh" ]

ARG VERSION
ARG RELEASE
LABEL name="Recorder-moe/s3-uploader" \
    # Authors for Recorder-moe
    vendor="Recorder-moe" \
    # Maintainer for this docker image
    maintainer="jim60105" \
    # Dockerfile source repository
    url="https://github.com/Recorder-moe/s3-uploader" \
    version=${VERSION} \
    # This should be a number, incremented with each change
    release=${RELEASE} \
    io.k8s.display-name="s3-uploader" \
    summary="s3-uploader: This script automates the process of uploading *.mp4 files from a local folder to S3 Blob Storage and delete them from the local folder." \
    description="This script automates the process of uploading *.mp4 files from a local folder to S3 Blob Storage and delete them from the local folder. It utilizes the MinIO Client(mc) to perform the upload. For more information about this tool, please visit the following website: https://github.com/Recorder-moe/s3-uploader"
