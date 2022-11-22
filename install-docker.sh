# Install minikube dependencies
yum -y -q install \
  iproute \
  iptables \
  ebtables \
  ethtool \
  ca-certificates \
  conntrack \
  socat \
  git \
  nfs-common \
  glusterfs-client \
  cifs-utils \
  apt-transport-https \
  ca-certificates \
  curl \
  lsb-release \
  gnupg \
  software-properties-common \
  bridge-utils \
  ipcalc \
  sudo

# Install docker
yum install -y yum-utils && yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
  && yum install -y -q docker-ce docker-ce-cli containerd.io docker-compose-plugin \
  && yum autoremove -y && yum clean all \
  && rm -rf /var/cache/ /tmp/* /var/tmp/*

sed -i 's@fd://@unix://@' /usr/lib/systemd/system/docker.service