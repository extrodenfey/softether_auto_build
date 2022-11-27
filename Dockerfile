FROM centos:8
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.epel.cloud|g' /etc/yum.repos.d/CentOS-Linux-*
RUN yum install epel-release -y &&\
        yum update -y &&\
        yum install libsodium libsodium-devel -y &&\
        yum -y groupinstall "Development Tools" &&\
        yum -y install cmake ncurses-devel openssl-devel readline-devel zlib-devel sudo  &&\
        useradd -m user && \
        echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user &&\
        cd /home/user &&\
        su - user  -c "git clone https://github.com/SoftEtherVPN/SoftEtherVPN.git" &&\
        cd /home/user/SoftEtherVPN  &&\
        ls &&\
        sudo -u user git submodule init && \
        sudo -u user git submodule update &&\
        sudo -u user ./configure &&\
        sudo -u user make -C build  package &&\
        sudo -u user mkdir /home/user/software  &&\
        sudo -u user cp -r /home/user/SoftEtherVPN/build/softether-*  /home/user/software/

USER user
WORKDIR /home/user/SoftEtherVPN
VOLUME ["/home/user/SoftEtherVPN"]
CMD ["bash"]

