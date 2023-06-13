#!/bin/sh

# Check if the search filter argument is provided
if [ -z "$1" ]; then
    echo "Please provide a search filter as an argument."
    exit 1
fi

# Set the search filter from the command-line argument
SEARCH_FILTER="$1"

# Check if the destination bucket environment variable is set
if [ -z "$DESTINATION_BUCKET" ]; then
    echo "Please set the DESTINATION_BUCKET environment variable."
    exit 1
fi

# Check if the destination directory environment variable is set
if [ -z "$DESTINATION_DIRECTORY" ]; then
    echo "Please set the DESTINATION_DIRECTORY environment variable."
    exit 1
fi

# Check if the S3 access key environment variable is set
if [ -z "$S3_ACCESS_KEY" ]; then
    echo "Please set the S3_ACCESS_KEY environment variable."
    exit 1
fi

# Check if the S3 secret key environment variable is set
if [ -z "$S3_SECRET_KEY" ]; then
    echo "Please set the S3_SECRET_KEY environment variable."
    exit 1
fi

# Check if the S3 endpoint environment variable is set
if [ -z "$S3_ENDPOINT" ]; then
    echo "Please set the S3_ENDPOINT environment variable."
    exit 1
fi

# Set the S3 alias
mc alias set mys3 "$S3_ENDPOINT" "$S3_ACCESS_KEY" "$S3_SECRET_KEY"

# Find files matching the search filter and store them in a temporary file
find "/toUpload" -name "*$SEARCH_FILTER*.mp4" >temp.txt

# Check if any matching files were found
if [ ! -s "temp.txt" ]; then
    echo "No matching files found."
    rm temp.txt
    exit 1
fi

echo "Uploading files..."

# Upload files matching the search filter to S3 storage using the MinIO Client (mc)
while IFS= read -r file_path; do
    mc cp "$file_path" "mys3/$DESTINATION_BUCKET/$DESTINATION_DIRECTORY"
done <temp.txt

# Delete the uploaded files
while IFS= read -r file_path; do
    rm "$file_path"
done <temp.txt

# Remove the temporary file
rm temp.txt
