from flask import Flask, request, jsonify, send_from_directory
import boto3

app = Flask(__name__)

s3 = boto3.client("s3")
dynamodb = boto3.resource("dynamodb")

@app.route("/")
def index():
    return send_from_directory("frontend", "index.html")

@app.route("/upload", methods=["POST"])
def upload():

    file = request.files["file"]

    s3.upload_fileobj(
        file,
        "my-bucket",
        f"uploads/{file.filename}"
    )

    return "ok"

@app.route("/files")
def files():

    table = dynamodb.Table("files")

    res = table.scan()

    return jsonify(res["Items"])
