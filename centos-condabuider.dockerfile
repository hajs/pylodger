# Start with
#  docker run -v=/:/mnt -v=/run/shm:/dev/shm -p=2222:22 -p=8000:8000 -h=conda -t -i IMAGE_ID /usr/sbin/sshd -D

FROM centos
MAINTAINER Henning Schroeder <henning.schroeder@gmail.com>
EXPOSE 22
RUN yum -y groupinstall "Development tools"
RUN yum install rsyslog openssh-server screen mercurial passwd
RUN sed 's/UsePAM yes/UsePAM no/' -i /etc/ssh/sshd_config
RUN sed 's/#PermitRootLogin yes/PermitRootLogin yes/' -i /etc/ssh/sshd_config
RUN sed 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' -i /etc/ssh/sshd_config
RUN /etc/init.d/rsyslogd restart
RUN /etc/init.d/sshd restart
RUN git clone https://github.com/hajs/pylodger.git /opt/conda-base
ENTRYPOINT ["/usr/sbin/sshd"]
CMD ["-D"]

