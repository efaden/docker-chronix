# == Dockerized ChronixDB
#

FROM phusion/baseimage:0.9.22

MAINTAINER Eric Faden <efaden@gmail.com>

ENV DEBIAN_FRONTEND="noninteractive" 

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Install Required Stuff
RUN apt-get -y update && apt-get -y install \
      zip \
      wget \
      unzip \
      lsof \
	&& rm -rf /var/lib/apt/lists/*

# Add Chronix Service
RUN mkdir /etc/service/chronix
COPY chronix.sh /etc/service/chronix/run
RUN chmod +x /etc/service/chronix/run

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Download and Install Chronix
RUN mkdir /chronix && \
      cd chronix && \
      wget https://github.com/ChronixDB/chronix.server/releases/download/v0.5-beta/chronix-0.5-beta.zip && \
      unzip chronix-0.5-beta.zip && \
      mv chronix-*/* ./ && \
      rm -rf rm -rf chronix-solr-* chronix-0.5-beta.zip && \
      chmod +x ./bin/solr

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME /data

EXPOSE 8983 8984
