# Node.js DevSecOps Example Project

This repository demonstrates a Node.js application with a complete DevSecOps pipeline using Jenkins, SonarQube, OWASP Dependency Check, Trivy, and Docker Scout.

## Features

- Simple Express.js web server (`index.js`)
- Dockerized build (`Dockerfile`)
- Automated CI/CD pipeline (`Jenkinsfile`)
- Security scanning (OWASP, Trivy, Docker Scout)
- SonarQube code analysis

## Getting Started

### Prerequisites

- Node.js 20+
- Docker
- Jenkins (with required plugins)
- SonarQube server
- Trivy
- Docker Scout CLI

### Installation

```sh
npm install
```

### Running Locally

```sh
npm start
```

Visit [http://localhost:3001](http://localhost:3001) in your browser.

### Docker

Build and run the Docker container:

```sh
docker build -t nodejs-devsecops:latest .
docker run -p 3001:3001 nodejs-devsecops:latest
```

## CI/CD Pipeline

The `Jenkinsfile` automates:

- Workspace cleanup
- Source checkout
- SonarQube analysis
- Dependency and image vulnerability scans
- Docker image build and push
- Docker Scout analysis

## Security

- **OWASP Dependency Check**: Scans for vulnerable dependencies.
- **Trivy**: Scans filesystem and Docker images for vulnerabilities.
- **Docker Scout**: Provides quick security insights on Docker images.

## License

This project is licensed under the ISC License.

---

**Author:**  
Rimas