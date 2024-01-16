# S3 Blob Storage Uploader

This script automates the process of uploading *.mp4 files from a local folder to S3 Blob Storage **and delete them** from the local folder. It utilizes the [MinIO Client(mc)](https://min.io/docs/minio/linux/reference/minio-mc.html) to perform the upload.

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
   - `DESTINATION_DIRECTORY`: The directory path within the destination bucket where you want to upload the files. (No slash at the beginning or end)

1. The script will upload the matching files to S3 Blob Storage and **delete them** from the local folder.

> **Note**\
> Take a look at the [docker-compose.yml](docker-compose.yml) file for an example of how to run the container with Docker Compose.

## Notes

- This script is written in sh syntax and has been tested in docker image only.
- I am a novice in sh script, and I used ChatGPT to create it, including this README file.😎
  1. <https://chat.openai.com/share/c694c95d-21ed-4d04-afb4-b650e0c43688>
  1. <https://chat.openai.com/share/e441bc42-5c38-4188-9785-a72543abee73>

## LICENSE

> [!CAUTION]
> An AGPLv3 licensed Dockerfile means that you _**MUST**_ **distribute the source code with the same license**, if you
>
> - Re-distribute the image. (You can simply point to this GitHub repository if you doesn't made any code changes.)
> - Distribute a image that uses code from this repository.
> - Or **distribute a image based on this image**. (`FROM ghcr.io/recorder-moe/s3-uploader` in your Dockerfile)
>
> "Distribute" means to make the image available for other people to download, usually by pushing it to a public registry. If you are solely using it for your personal purposes, this has no impact on you.
>
> Please consult the [LICENSE](LICENSE) for more details.

<img src="https://github.com/Recorder-moe/s3-uploader/assets/16995691/cb3b53a6-7eff-409b-9dca-bb59f52d3117" alt="agplv3" width="300" />

[GNU AFFERO GENERAL PUBLIC LICENSE Version 3](/LICENSE)

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
