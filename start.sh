#!/bin/bash -e

child=0
sig_handler() {
    sig_send=$1
    code=$2
    if [ $child -ne 0 ]; then
        kill -$sig_send $child
        wait $child
    fi
    exit $code
}
trap 'sig_handler HUP 129' HUP
trap 'sig_handler TERM 130' INT
trap 'sig_handler TERM 131' QUIT
trap 'sig_handler TERM 143' TERM

tail -F /var/log/minikube-start.log &
child=$!

export CNI_BRIDGE_NETWORK_OFFSET="0.0.1.0"

systemctl start containerd &

LOG_DIR=/var/log/minikube
mkdir -p "${LOG_DIR}"
HOST_IP=$(ip route get 1 | sed -n 's/^.*src \([0-9.]*\) .*$/\1/p')
START_ARGS="--vm-driver=none --image-mirror-country=${IMAGE_MIRROR_COUNTRY} --apiserver-ips=${HOST_IP} --kubernetes-version=${K8S_VERSION} --log_dir=${LOG_DIR}"

echo Starting minikube: minikube start ${START_ARGS} "$@"
minikube start ${START_ARGS} "$@" >& /var/log/minikube-start.log \
    || (printf "\n\n*** Minikube start failed ***\n\n"; sleep 2; false)

minikube kubectl config view > /kubeconfig

echo Kubeconfig is ready

# Put the tail of logs in the foreground to keep the  container running
wait $child