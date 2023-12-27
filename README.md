# ActualBudget Server with Cloudflare Tunnel Access

This repository contains the configuration files for deploying the ActualBudget server on Fly.io with access via a Cloudflare tunnel.

## Main Function

The main function of this project is to serve the ActualBudget application. It does this by running a Node.js server (as defined in `app.js`) and setting up a Cloudflare tunnel for secure access.

## How to Reproduce

To reproduce this setup, follow these steps:

1. Fork or clone this repository to your own GitHub account.
2. Navigate to the repository settings and add the following secrets:
   - `FLY_APP`: The name of your Fly.io application.
   - `FLY_API_TOKEN`: Your Fly.io API token.
   - `CF_TOKEN`: Your Cloudflare token.
3. Run the GitHub Action workflow `deploy-fly.yml`. This will build the Docker image and deploy the application on Fly.io.

Once the deployment is complete, you can access your application via the URL provided by Fly.io.

## Configuration

The deployment process is configured using the following files:

- `.github/workflows/deploy-fly.yml`: The GitHub Actions workflow file that defines the deployment pipeline.
- `fly.toml`: The Fly.io configuration file that specifies the application settings.
- `Dockerfile`: The Dockerfile used to build the application.
- `Procfile`: This file specifies the commands that are executed by the app on startup.

## License

This project is licensed under the [MIT License](LICENSE) - see the [LICENSE](LICENSE) file for details.

## Author

- [MartinatorTime](https://github.com/MartinatorTime)

Feel free to reach out with any questions, issues, or suggestions!