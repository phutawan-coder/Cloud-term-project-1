from flask import Flask, request, jsonify, render_template
import boto3

app = Flask(__name__)


session = boto3.Session(region_name="ap-southeast-2")
s3 = session.client("s3")
dynamodb = session.resource("dynamodb")

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/upload", methods=["POST"])
def upload():

    file = request.files["file"]
    filename = file.filename
    
    s3.upload_fileobj(
        file,
        "s3-bucket-cloud-project-2026",
        f"uploads/{filename}",
    )

    return "ok"

@app.route("/files")
def files():

    table = dynamodb.Table("file-metadata")

    res = table.scan()

    return jsonify(res["Items"])

@app.route("/download/<path:key>")
def generate_url(key):

    url = s3.generate_presigned_url(
        "get_object",
        Params={
            "Bucket": "s3-bucket-cloud-project-2026",
            "Key": key
        },
        ExpiresIn=300
    )

    return jsonify({"url": url})
