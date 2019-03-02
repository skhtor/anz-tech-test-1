## ANZ Technical Test 1

Contains a Dockerfile which builds a slim java container and imports certs into the keystore.

#### Requirements

- Docker
- Certificates which you want imported

#### Setup

##### Import your certs into a `certificates` folder in the root project directory

```
mkdir certificates
cp <cert_path> certificates
```

##### Build the image

`docker build . -t <name>`

The Dockerfile copies the certs in the `certificates` folder onto the container and imports them into the keystore


#### Run the container

`docker run -it --rm <name> /bin/bash`
