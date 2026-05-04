# Currency Tracker Frontend

This is the frontend application for the Currency Insight Tracker V2, providing a responsive dashboard for visualizing currency fluctuations.

## Key Technical Specifications
- **Framework**: React 18 (Vite)
- **Styling**: Tailwind CSS
- **Visualization**: Recharts
- **Deployment**: Amazon S3 + CloudFront

## Project Structure
- `/src/components`: UI components including charts and data displays.
- `/src/App.jsx`: Main application logic and API fetching.
- `vite.config.js`: Vite configuration for the build process.

## Local Development

### Installation
```bash
npm install
npm run dev
```
### Environment Variables

For local development, create a `.env` file or set the following variables:
- `VITE_API_URL`: The URL of your backend API (ALB or CloudFront URL).

## Build and Deployment
- **Build**: `npm run build` generates static assets in the dist/ directory.
- **CI/CD**: Assets are automatically synced to Amazon S3 and the CloudFront cache is invalidated upon a push to the main branch.