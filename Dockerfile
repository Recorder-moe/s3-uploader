FROM minio/mc

# Set the working directory
WORKDIR /app

RUN microdnf install findutils \
    && microdnf clean all

# Copy the bash script into the container
COPY s3-uploader.sh .

# Set the script as executable
RUN chmod +x s3-uploader.sh

# Set environment variables
ENV S3_ENDPOINT=""
ENV S3_ACCESS_KEY=""
ENV S3_SECRET_KEY=""
ENV DESTINATION_BUCKET=""
ENV DESTINATION_DIRECTORY=""

VOLUME [ "/toUpload" ]

# Execute the script with provided settings
ENTRYPOINT ["./s3-uploader.sh"]
