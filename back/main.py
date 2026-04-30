from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"message": "Currency Tracker V2 API is running on ECS"}

@app.get("/api/health")
def health_check():
    return {"status": "healthy"}

@app.get("/api/rates")
def get_rates():
    return {"data": "todo"}

    