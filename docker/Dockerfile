From postgres:11

WORKDIR /app

#install git
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y gcc make flex bison byacc git

#clone the tpc-ds tool kit
RUN git clone https://github.com/gregrahn/tpcds-kit.git
WORKDIR tpcds-kit/tools
RUN make OS=LINUX

COPY load-data.sh /app/tpcds-kit/tools
COPY query_explain /app/tpcds-kit/tools/query_explain
COPY query_analyze /app/tpcds-kit/tools/query_analyze
COPY execute_explain.sh /app/tpcds-kit/tools
COPY execute_analyze.sh /app/tpcds-kit/tools