FROM centos:7

COPY install-docker.sh /install-docker.sh

RUN  chmod +x /install-docker.sh && /install-docker.sh

VOLUME /var/lib/docker
EXPOSE 2375
EXPOSE 8443

ENV MINIKUBE_VERSION=latest \
    K8S_VERSION=v1.23.0 \
    CHANGE_MINIKUBE_NONE_USER=true \
    IMAGE_MIRROR_COUNTRY='cn'

COPY start.sh /start.sh

# systemctl is needed by minikube,while docker container doesn't support that.
# to use the fake systemctl is a way based on <https://github.com/gdraheim/docker-systemctl-replacement/blob/master/files/docker/systemctl.py> 
COPY systemctl.py /usr/bin/systemctl

ADD https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION}/minikube-linux-amd64 /usr/local/bin/minikube

RUN chmod a+rx /usr/local/bin/minikube && \
    chmod a+rx /start.sh && \
    chmod +x /usr/bin/systemctl


# Start up docker and then pass any "docker run" args to minikube start
ENTRYPOINT [ "/start.sh" ]
