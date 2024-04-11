# openresty-docker-playground
A sandbox for exploring Nginx and LUA with OpenResty in Docker.
Quickly spin up a pre-configured Docker container and dive into Nginx and Lua.
Modify existing locations and code to experiment and develop your own solutions.

## Table of Contents
- [Introduction](#introduction)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
    - [Installation](#installation)
      - [Clone the Repository](#clone-the-repository)
      - [Build and Run the Container](#build-and-run-the-container)
- [Usage](#usage)
  - [Nginx Locations](#nginx-locations)
  - [Testing with cURL](#testing-with-curl)
  - [Exploring Nginx and Lua Integration](#exploring-nginx-and-lua-integration)
- [License](#license)

## Introduction
The `openresty-docker-playground` project provides a pre-configured Docker environment for exploring and developing with the Nginx web server and Lua programming language through the OpenResty platform. This sandbox allows users to modify and extend Nginx server configurations and Lua scripts to experiment with various web server functionalities, such as rate limiting, JWT authentication, and dynamic content generation.

## Getting Started
This repository contains a [Docker Compose configuration](docker-compose.yml) that builds an OpenResty container with a pre-configured Nginx configuration and multiple different Lua scripts.
From restricting locations to rate limiting, JWT verification, and image transformation, this sandbox provides a variety of examples to experiment with.

### Prerequisites
Before you begin, ensure you have installed the following tools:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- For testing API endpoints: [Insomnia](https://insomnia.rest/download) or [Postman](https://www.postman.com/downloads/) (optional)

### Installation

#### Clone the Repository
Start by cloning the project repository to your local machine:
```bash
git clone git@github.com:bulletinmybeard/nginx-lua-openresty-playground.git
````

#### Build and Run the Container
Navigate to the project directory and start the Docker container. This step builds the Docker image if it's not already built or rebuilds it if any changes were made.

```bash
cd nginx-lua-openresty-playground
docker-compose up --build
```

## Usage
### Nginx Locations
The provided Docker setup comes with multiple pre-configured Nginx locations, demonstrating various functionalities.
You can test these endpoints using `cURL` or by importing the provided REST API collections into Insomnia or Postman from the [insomnia-postman-configs](insomnia-postman-configs) directory.

| Request method | Location                      | Authentication       | Body/Get Query parameters                                | Description                                                                                    |
|----------------|-------------------------------|----------------------|----------------------------------------------------------|------------------------------------------------------------------------------------------------|
| ANY            | `/lua_logs`                   | N/A                  | N/A                                                      | Logs messages at various severity levels. Returns a 204 No Content.                            |
| POST           | `/post_data`                  | N/A                  | JSON payload                                             | Processes POST requests with JSON payloads. Returns a JSON response with processing details.   |
| ANY            | `/json_data`                  | N/A                  | N/A                                                      | Creates a sample JSON payload.                                                                 |
| ANY            | `/rate_limited`               | N/A                  | N/A                                                      | Implements rate limiting.                                                                      |
| ANY            | `/api_token_auth`             | X-API-TOKEN header   | N/A                                                      | Performs authentication using an API token. Returns a simple success message if authenticated. |
| ANY            | `/inject_headers`             | N/A                  | N/A                                                      | Custom header manipulation. Adds several custom headers.                                       |
| POST           | `/jwt/sign`                   | N/A                  | JSON payload                                             | JWT generation. Returns the generated JWT token as the response.                               |
| ANY            | `/jwt/verify`                 | Authorization header | N/A                                                      | JWT verification. Returns the decoded JWT payload as a JSON response.                          |
| ANY            | `/jwt/page`                   | Authorization header | N/A                                                      | JWT verification with robust error handling. Returns a success message or a 401 response.      |
| ANY            | `/shared_cache`               | N/A                  | N/A                                                      | Demonstrates using the Nginx shared content cache. Returns the retrieved content.              |
| ANY            | `/query_params`               | N/A                  | Query string arguments                                   | Modifies and outputs query string arguments as a JSON-encoded string.                          |
| ANY            | `/metrics`                    | N/A                  | N/A                                                      | Tracks and exposes request metrics. Returns the metrics as a JSON payload.                     |
| ANY            | `/transform_image`            | N/A                  | Image data (blob), query arguments for dimensions/rotate | Image resizing and transformation. Sends the resized image data in the response.               |
| GET, POST      | `/request_method_restriction` | N/A                  | N/A                                                      | Restricts the allowed HTTP methods to GET and POST.                                            |
| ANY            | `/get_yaml_config`            | N/A                  | N/A                                                      | Generates a JSON response containing config values.                                            |
| ANY            | `/get_env_vars`               | N/A                  | N/A                                                      | Accesses environment variables and returns them in a JSON payload.                             |
| ANY            | `/health`                     | N/A                  | N/A                                                      | Health check endpoint. Returns a JSON payload indicating a "healthy" status.                   |
| ANY            | `/`                           | N/A                  | N/A                                                      | Default route. Returns "OK".                                                                   |

### Testing with cURL
Below are examples of how you can use cURL to test some of the Nginx locations:

```bash
curl --request PUT \
  --url http://localhost:8080/request_method_restriction \
  --header 'Accept: application/json' \
  --header 'User-Agent: Mozilla/5.0 Chrome/110.0.0.0 Safari'

curl --request GET \
  --url http://localhost:8080/get_yaml_config \
  --header 'Accept: application/json' \
  --header 'User-Agent: Mozilla/5.0 Chrome/110.0.0.0 Safari'

curl --request POST \
  --url http://localhost:8080/post_data \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: Mozilla/5.0 Chrome/110.0.0.0 Safari' \
  --data '{
	"john": "doe"
  }'
```

### Exploring Nginx and Lua Integration
The main Nginx configuration file ([nginx.conf](docker/nginx/nginx.conf)) and the project-specific [local.conf](docker/nginx/conf.d/local.conf) file outline server directives and locations.
Lua scripts and modules can be found within the project's directory [docker/lua](docker/lua).

The Docker container is configured to automatically reload the Nginx server upon changes to Lua scripts or Nginx configuration files, facilitated by a monitoring script ([monitor.sh](docker/scripts/monitor.sh)).

Logs generated by Nginx, Lua, and the monitoring script are stored in `/var/log`, structured as follows:

```bash
├── lua
│   └── default.log
├── monitor-errors.log
├── monitor.log
├── nginx.local.access.log
└── nginx.local.error.log
```

## License
This project is open-sourced under the MIT License. For more details, see the [LICENSE](LICENSE) file included with the source code.