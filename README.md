# Minikube in Docker-in-Docker (minikube-dind)

## build image

```
docker build -t gkilm/minikube-dind .
```

## run container

```
# set IMAGE_MIRROR_COUNTRY='' for non-Chinese mainland users
docker run --privileged -d --rm -it gkilm/minikube-dind
```