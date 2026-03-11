import json
import boto3
import os
from PIL import Image
import fitz
from io import BytesIO
import uuid
from datetime import datetime

s3 = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')

TABLE_NAME = "file-metadata"

table = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):

    record = event['Records'][0]
    bucket = record['s3']['bucket']['name']
    key = record['s3']['object']['key']
    filename = os.path.basename(key)

    input_path = f"/tmp/{filename}"
    output_path = f"/tmp/processed_{filename}"

    # download file
    s3.download_file(bucket, key, input_path)
    
    ext = filename.lower().split(".")[-1]

    # ---------- IMAGE ----------
    if ext in ["jpg", "jpeg", "png"]:

        img = Image.open(input_path)

        img_format = img.format or "JPEG"

        img = img.resize((int(img.size[0]/2), int(img.size[1]/2)))

        img.save(output_path, img_format, optimize=True, quality=75)

    # ---------- PDF ----------
    elif ext == "pdf":

        doc = fitz.open(input_path)

        doc.save(output_path, garbage=4, deflate=True)

        doc.close()

    else:
        return {"status": "unsupported file"}

    # upload กลับ S3
    s3.upload_file(output_path, bucket, f"processed/{filename}")

    file_id = str(uuid.uuid4())

    # save metadata
    table.put_item(
        Item={
            "file_id": file_id,
            "filename": filename,
            "filetype": ext,
            "bucket": bucket,
            "key": key,
            "time": datetime.utcnow().isoformat()
        }
    )

    return {
        "statusCode": 200,
        "body": json.dumps("File processed"),
        "key": key,
        "bucket": bucket,
    }
