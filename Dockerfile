# A CentOS7 Stack image using upstream repo
FROM centos:7
MAINTAINER Brian C. Lane <bcl@redhat.com>

# systemd enabled container (from https://hub.docker.com/_/centos/)
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;



# Install Cockpit, lorax-composer, and welder-web
RUN yum -y install cockpit less; yum clean all; \
systemctl enable cockpit.socket; \
echo "root:ChangeThisLamePassword" | chpasswd

EXPOSE 9090
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]


# Run this image with cgroups mounted:
# docker run -ti -v /sys/fs/cgroup:/sys/fs/cgroup:ro --security-opt="label:disable" -p 9090 --rm weldr/centos7-composer
