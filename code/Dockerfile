FROM ubuntu:14.04
MAINTAINER Guoyan Huang <example@example.com>
RUN apt-get update
RUN mkdir /oa/
RUN mkdir /oa/GF_2015_OA_8080
RUN echo "helloworld"
RUN echo "helloworld"
RUN echo "helloworld"
RUN echo "helloworld"
ADD jdk-6u45-linux-x64.bin /oa/
ADD buildJdk.sh /oa/
ADD GF_2015_OA_8080 /oa/GF_2015_OA_8080
ADD run.sh /oa/
EXPOSE 9985 9986 9457 8017 8080 9579 6787 5827 5828 27
CMD bash /oa/run.sh
