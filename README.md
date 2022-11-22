# Minikube in Docker-in-Docker (minikube-dind)

## build image

```
docker build -t gkilm/minikube-dind .
```

## run container

```
docker run --privileged -d --rm -it gkilm/minikube-dind
```