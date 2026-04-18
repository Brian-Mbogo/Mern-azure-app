# Mern-azure-app

Repository for a MERN (MongoDB, Express, React, Node) application prepared for deployment to Microsoft Azure.

## Repository layout
- `server/` — Node/Express backend. The server serves the production React build from `../client/build`.
- `client/` — React frontend (expected sibling to `server` at the repository root).
- `README.md` — This documentation.

## Purpose
This repository contains the backend and frontend resources required to deploy a MERN application to Azure App Service with MongoDB hosted on MongoDB Atlas.

## Prerequisites
- A Microsoft Azure account and access to the Azure Portal.
- A MongoDB Atlas account and a running cluster.
- Git and a GitHub account (optional, used for automatic deployments).

## Required environment variables
- `MONGO_URI`: MongoDB Atlas connection string (include credentials and DB name).
- `PORT`: Optional (Azure sets this automatically when the app runs in App Service).

Note: Do not commit secrets. Add `server/.env` to `.gitignore`. Provide `server/.env.example` for documentation of required variables.

## Local development
1. Install backend dependencies:
```powershell
cd 'server'
npm install
```
2. Install frontend dependencies (if `client/` exists):
```powershell
cd '..\client'
npm install
```
3. Run frontend in development mode:
```powershell
cd '..\client'
npm start
```
4. Run backend in development mode (from `server`):
```powershell
cd 'server'
npm start
```

## Building for production
1. Build the React application:
```powershell
cd 'client'
npm run build
```
2. Verify the build output exists at `client/build`.
3. Start the backend in production mode (server will serve `client/build`):
```powershell
cd 'server'
npm start
```

## Azure deployment checklist (Checkpoint compliance)
The following steps match the checkpoint requirements for hosting a MERN app on Microsoft Azure.

1. MongoDB Atlas
   - Create a MongoDB Atlas cluster and a database user with appropriate privileges.
   - Configure network access (IP whitelist) for the application or use a secure method such as VPC peering where available.

2. Prepare application for deployment
   - Use environment variables for sensitive configuration (`MONGO_URI`, etc.).
   - Ensure the React app is built (`client/build`) before deployment.
   - Confirm the backend serves static files from `client/build` (see `server/server.js`).

3. Create Azure App Service
   - In the Azure Portal, create a Web App (App Service). Choose runtime stack (Node 16/18+) and an appropriate region and pricing tier.

4. Configure application settings in Azure
   - In the Web App -> Configuration, add `MONGO_URI` and any other required environment variables as Application Settings.

5. Deployment methods
   - GitHub: Connect the repository to the Web App for continuous deployment from a branch (recommended).
   - Local Git: Use the App Service Git endpoint and push the built code.
   - ZIP deploy or Azure CLI: Upload the build artifact.

6. Deployment specifics
   - If using GitHub Actions, include steps to install dependencies, build the client, and deploy the server (or use the `azure/webapps-deploy` action).
   - Ensure the `client` build step runs before deployment so `client/build` is present for the server to serve.

7. Test deployed application
   - Visit the App Service URL and test API endpoints and UI.
   - Verify MongoDB connectivity through logs or application behavior.

## Example commands (PowerShell)
- View README locally:
```powershell
Get-Content 'c:\Users\( F r E a K )\gomycode\mern-azure-app\README.md' -Raw
```
- Build client and start server locally:
```powershell
cd 'c:\Users\( F r E a K )\gomycode\mern-azure-app\client'
npm install
npm run build

cd '..\server'
npm install
npm start
```

## Recommended repository hygiene
- Keep `server/.env` and any credential files out of source control. Add a `server/.env.example` containing variable names without secrets.
- Add a `.github/workflows/` GitHub Actions workflow to automate builds and deployments.

## Notes and next steps
- Confirm that the `client/` directory exists and is the correct React app.
- Create `server/.env.example` documenting required environment variables.
- Optionally add CI/CD via GitHub Actions or an Azure deployment workflow.

## Alternate deployment methods
The repository includes optional artifacts for different deployment approaches:

- `Dockerfile` (repo root): multi-stage Dockerfile that builds the React `client` and runs the `server`. Useful for containerized deployments (Azure Container Instances, Azure Web App for Containers, or other container hosts).

   Build and run locally:
   ```powershell
   cd 'c:\Users\( F r E a K )\gomycode\mern-azure-app'
   docker build -t mern-azure-app:latest .
   docker run -p 3000:3000 -e MONGO_URI="<uri>" mern-azure-app:latest
   ```

- `server/web.config`: configuration for Azure App Service on Windows using IISNode. Place this file in the `server` folder so that `server.js` is used as the application entry point when deploying to Windows-based App Service.

- `Procfile` (repo root): `web: node server/server.js` — useful for platforms that respect Procfile conventions (Heroku, some CI deployers).

Choose the artifact that best matches the target environment. For Azure App Service, prefer:

- Linux App Service with the GitHub Actions workflow already included (recommended), or
- App Service on Windows with `server/web.config` if using a Windows plan.


## Repository secrets and Azure publish profile
This repository uses GitHub Actions to build the `client` and deploy the project to Azure App Service. The workflow requires two repository secrets:

- `AZURE_WEBAPP_NAME` — the name of the Azure Web App (App Service) to deploy to.
- `AZURE_PUBLISH_PROFILE` — the publish profile XML for the Azure Web App. The publish profile contains credentials used by the GitHub action to deploy.

Steps to add the required GitHub secrets:

1. Open the repository on GitHub and go to `Settings` → `Secrets and variables` → `Actions` → `New repository secret`.
2. Create a secret named `AZURE_WEBAPP_NAME` and set its value to the App Service name (for example: `my-mern-app`).
3. Create a secret named `AZURE_PUBLISH_PROFILE` and paste the entire contents of the downloaded publish profile file (an XML file) as the value.

How to obtain the Azure publish profile:

1. In the Azure Portal navigate to the target Web App (App Service).
2. On the Web App page, select `Get publish profile` (usually located in the Overview or Get publish profile action). This downloads a `.PublishSettings` file.
3. Open the `.PublishSettings` file in a text editor and copy its full contents.
4. Paste the copied XML into the `AZURE_PUBLISH_PROFILE` secret value on GitHub and save.

Additional Azure configuration notes:

- Add `MONGO_URI` and any other environment variables in the Web App -> Configuration -> Application settings on the Azure Portal. These values are injected into the running app at runtime.
- The App Service `PORT` is provided by Azure; the server code already reads `process.env.PORT` and falls back to `3000` for local testing.

Verifying deployment and troubleshooting:

- After pushing to `main`, check the Actions tab on GitHub. The workflow run will show logs for dependency install, client build, and deploy steps.
- If deployment fails, review the `azure/webapps-deploy` step logs for the publish/profile authentication errors or file upload issues.
- On Azure, use the Web App `Log stream` and `Deployment center` logs to diagnose runtime or deployment errors.

Security reminder:

- Never commit secrets or `.env` files containing credentials. Keep `server/.env` in `.gitignore` and only keep `server/.env.example` (without real values) in the repo.


