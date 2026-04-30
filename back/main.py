from fastapi import FastAPI
import boto3
from boto3.dynamodb.conditions import Key

# Load .env
import os
from dotenv import load_dotenv

load_dotenv()

# FastAPI starts here
app = FastAPI()

dynamodb = boto3.resource("dynamodb", region_name=os.getenv("AWS_REGION_NAME"))
table = dynamodb.Table(os.getenv("AWS_DYNAMODB_TABLE_NAME"))


@app.get("/")
def read_root():
    return {"message": "Currency Tracker V2 API is running on ECS"}


@app.get("/api/health")
def health_check():
    return {"status": "healthy"}


@app.get("/api/rates")
def get_rates():
    try:
        response = table.scan()
        items = response.get("Items", []) or []

        sorted_items = sorted(items, key=lambda x: x["Date"])

        return sorted_items
    except Exception as e:
        return {"error": str(e)}
