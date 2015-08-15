# Start with
#  docker run -v=/:/mnt -v=/run/shm:/dev/shm -p=2222:22 -p=8000:8000 -h=conda -t -i IMAGE_ID /usr/sbin/sshd -D

FROM centos:6
MAINTAINER Henning Schroeder <henning.schroeder@gmail.com>
EXPOSE 22
RUN yum -y update && yum clean all
RUN yum -y groupinstall "Development tools"
RUN yum install -y libXext libSM libXrender fontconfig mesa-libGL rsyslog openssh-server screen mercurial passwd gcc-gfortran expat-devel bison byacc flex gsl-devel antlr tar bzip2 patch file make gcc-c++ wget git libtool texinfo
RUN sed 's/UsePAM yes/UsePAM no/' -i /etc/ssh/sshd_config
RUN sed 's/#PermitRootLogin yes/PermitRootLogin yes/' -i /etc/ssh/sshd_config
RUN sed 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' -i /etc/ssh/sshd_config
RUN /etc/init.d/rsyslogd restart
RUN /etc/init.d/sshd restart
RUN git clone https://github.com/hajs/pylodger.git /opt/conda-base
ENV PATH /opt/buildconda/bin:$PATH
ENTRYPOINT ["/usr/sbin/sshd"]
CMD ["-D"]

