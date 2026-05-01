from fastapi import FastAPI, Query, HTTPException
from datetime import datetime, timedelta
import logging
import boto3
from boto3.dynamodb.conditions import Key

# Logging setup
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# FastAPI starts here
app = FastAPI()

import os
REGION = os.getenv("AWS_REGION", "us-west-2")
TABLE_NAME = os.getenv("DYNAMODB_TABLE", "CurrencyRates")

dynamodb = boto3.resource("dynamodb", region_name=REGION)
table = dynamodb.Table(TABLE_NAME)


@app.get("/")
def read_root():
    return {"message": "Currency Tracker V2 API is running on ECS"}


@app.get("/api/health")
def health_check():
    return {"status": "healthy"}


@app.get("/api/rates")
async def get_rates(
    pair: str = Query("CAD_KRW", description="Currency pair to fetch"),
    days: int = Query(30, description="Number of days to look back"),
):
    end_date = datetime.now().strftime("%Y-%m-%d")
    start_date = (datetime.now() - timedelta(days=days)).strftime("%Y-%m-%d")

    try:
        logger.info(f"Querying {pair} from {start_date} to {end_date}")

        response = table.query(
            KeyConditionExpression=Key("CurrencyPair").eq(pair)
            & Key("Date").between(start_date, end_date)
        )

        items = response.get("Items", [])

        return {
            "pair": pair,
            "range": f"{start_date} to {end_date}",
            "count": len(items),
            "data": items,
        }

    except Exception as e:
        logger.error(f"DynamoDB Query Error: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
