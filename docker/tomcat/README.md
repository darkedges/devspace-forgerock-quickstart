# Docker: Tomcat base for ForgeRock

This is a Tomcat 9.0.65 container, based on eclipse-temurin:11.0.14_9-jdk-alpine

## Build

To build the container:

```bash
git clone git clone https://github.com/darkedges/docker-darkedges-tomcat.git
cd docker-darkedges-tomcat

# To build
docker build . --rm -t darkedges/tomcat:9.0.65-11.0.14_9-alpine
```
