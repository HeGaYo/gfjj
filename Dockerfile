FROM ubuntu:14.04
MAINTAINER Guoyan Huang <example@example.com>
RUN apt-get update
RUN apt-get install unrar
RUN mkdir /oa/
ADD GF_2015_OA_8080.rar /oa/
ADD jdk-6u45-linux-x64.bin /oa/
ADD buildJdk.sh /oa/
ADD run.sh /oa/
