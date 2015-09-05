FROM ubuntu:trusty
MAINTAINER ClassCat Co.,Ltd. <support@classcat.com>

########################################################################
# ClassCat/Spark Dockerfile
#   Maintained by ClassCat Co.,Ltd ( http://www.classcat.com/ )
########################################################################

#--- HISTORY -----------------------------------------------------------
# 05-sep-15 : fixed.
#
#--- TODO --------------------------------------------------------------
# 04-sep-15 : should be run as non-root ?
#
#--- DESCRIPTION -------------------------------------------------------
# 04-sep-15 : python-numpy, python-matplotlib, python-nose : o.k.
#
#-----------------------------------------------------------------------

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y upgrade \
  && apt-get install -y language-pack-en language-pack-en-base \
  && apt-get install -y language-pack-ja language-pack-ja-base \
  && update-locale LANG="en_US.UTF-8" \
  && apt-get install -y openssh-server supervisor rsyslog \
  && mkdir -p /var/run/sshd \
  && sed -i.bak -e "s/^PermitRootLogin\s*.*$/PermitRootLogin yes/" /etc/ssh/sshd_config

COPY assets/supervisord.conf /etc/supervisor/supervisord.conf

# OpenJDK 8
RUN apt-get install -y software-properties-common \
  && apt-add-repository ppa:openjdk-r/ppa \
  && apt-get update \
  && apt-get install -y openjdk-8-jdk

# Apache Spark
WORKDIR /usr/local
RUN wget http://ftp.riken.jp/net/apache/spark/spark-1.4.1/spark-1.4.1-bin-hadoop2.6.tgz \
  && tar xfz spark-1.4.1-bin-hadoop2.6.tgz \
  && ln -s spark-1.4.1-bin-hadoop2.6 spark

# ipython & notebook & libraries
RUN apt-get install -y ipython ipython-notebook \
  && apt-get install -y python-scipy python-pandas python-sympy \
  && ipython profile create ccnb

WORKDIR /root
COPY assets/ipython_notebook_config.py /root/.ipython/profile_ccnb/ipython_notebook_config.py
COPY assets/pwgen.py /opt/pwgen.py

WORKDIR /opt
COPY assets/cc-init.sh /opt/cc-init.sh

#EXPOSE 22 80

CMD /opt/cc-init.sh; /usr/bin/supervisord -c /etc/supervisor/supervisord.conf


### End of Dockerfile ###
