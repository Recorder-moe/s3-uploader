# S3 Blob Storage Uploader

This script automates the process of uploading *.mp4 files from a local folder to S3 Blob Storage **and delete them** from the local folder. It utilizes the [MioIO Client(mc)](https://min.io/docs/minio/linux/reference/minio-mc.html) to perform the upload.

## Getting Started

1. Pull the Docker image from the registry:

   ```bash
   docker pull ghcr.io/recorder-moe/s3-uploader:latest
   ```

1. Run the Docker container, providing the search filter as a command:

   ```bash
   docker run -e S3_ENDPOINT="https://your-s3-endpoint" \
              -e S3_ACCESS_KEY="your-s3-access-key" \
              -e S3_SECRET_KEY="your-s3-secret-key" \
              -e DESTINATION_BUCKET="your-bucket" \
              -e DESTINATION_DIRECTORY="your/destination/directory" \
              ghcr.io/recorder-moe/s3-uploader:latest video
   ```

   Replace `https://your-s3-endpoint` `your-s3-access-key`, `your-s3-secret-key`, `your-bucket`, and `your/destination/directory` with your desired values. The `video` argument is the search filter for the *.mp4 files to upload.

   The environment variables:

   - `S3_ENDPOINT`: The endpoint of the S3-compatible storage. For example, "https://s3.amazonaws.com".
   - `S3_ACCESS_KEY`: The access key for your S3-compatible storage.
   - `S3_SECRET_KEY`: The secret key for your S3-compatible storage.
   - `DESTINATION_BUCKET`: The name of the bucket in the S3-compatible storage where you want to upload the files.
   - `DESTINATION_DIRECTOR`: The directory path within the destination bucket where you want to upload the files.

1. The script will upload the matching files to S3 Blob Storage and **delete them** from the local folder.

> **Note**\
> Take a look at the [docker-compose.yml](docker-compose.yml) file for an example of how to run the container with Docker Compose.

## Notes

- This script is written in sh syntax and has been tested in docker image only.
- I am a novice in sh script, and I used ChatGPT to create it, including this README file.😎

## License

This project is licensed under the [MIT License](LICENSE).
