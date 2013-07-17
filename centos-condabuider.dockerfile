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
RUN hg clone https://henning@bitbucket.org/henning/conda-base /opt/conda-base
ENTRYPOINT ["/usr/sbin/sshd"]
CMD ["-D"]

