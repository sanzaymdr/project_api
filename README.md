# project_api

## Requirements
You must have Docker & Docker Compose installed.
* [Docker](https://www.docker.com/get-started)
* [Docker Compose](https://docs.docker.com/compose/install/)


#### Setup
* These instructions assume you have following alias setup or setup alias: `dcd='docker-compose -f dcd.yml'`
* Install the dev requirements above.
* Clone the repo
* Navigate to the `project_api` directory.
* Checkout to `feat/api_implementation` branch.
* To build the app, run the `build_dev.sh` script in the root directory.
The script will build the docker images, creates & migrate database.

* Start the server with `dcd up`. The app will start on `localhost:3000`
#### Docker
* You can manually build the docker containers and build the app
1. Use `dcd build` or `docker-compose -f dcd.yml build` to build the containers.
bash into the web container and run the following commands
  ```
  rake db:create
  rake db:migrate
  ```
#### Run Unit Tests
* `dct run test` to perform full unit tests.
### Additional Gems & Modification
* Please refer to this [Document](https://docs.google.com/document/d/1JIcfU03ZUZOiYag9DwCgLEffrmyNIZq-vX10DKcyzrI/edit?usp=sharing)

### Postman API documentation
* Import this [LINK](https://www.getpostman.com/collections/1a440d785548e22961d7) to your Postman App.

