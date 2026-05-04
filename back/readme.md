# Currency Tracker Backend API

This is the containerized backend service for the Currency Insight Tracker V2. It is built with FastAPI and designed to run on AWS ECS Fargate.

## Key Technical Specifications
- **Framework**: FastAPI (Python 3.11+)
- **Database**: Amazon DynamoDB
- **Infrastructure**: AWS ECS (Fargate)
- **Containerization**: Docker (Multi-stage Build)

## Project Structure
- `main.py`: Core FastAPI application and API routing.
- `Dockerfile`: Configuration for containerizing the application using a lightweight Python image.
- `requirements.txt`: Python dependencies.

## Local Development

### Prerequisites
- Docker installed
- AWS Credentials (with DynamoDB Access)

### Running with Docker
1. Build the image:
   ```bash
   docker build -t currency-tracker-back .
   ```

2. Run the Container
    ```bash
    docker run -p 8000:8000 \
    -e AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY \
    -e AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY \
    -e AWS_REGION=us-west-2 \
    currency-tracker-back
    ```

## API Documentation
- **Endpoint**: `GET /api/rates`
- **Parameters**: 
  - `pair` (e.g., EUR_KRW)
  - `days` (e.g., 7)
- **Response**: JSON array of historical currency rates.