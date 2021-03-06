FROM ubuntu:14.04
MAINTAINER Sergiu Nisioi <sergiu.nisioi@gmail.com>

RUN apt-get update && apt-get install -y \
    build-essential \
    python-dev \
    python-pip \
    wget

RUN curl -s https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash -e
RUN git clone https://github.com/torch/distro.git ~/torch --recursive
RUN cd ~/torch && ./install.sh && \
    cd install/bin && \
    ./luarocks install nn && \
    ./luarocks install tds

RUN cd ~ && wget https://github.com/zeromq/zeromq2-x/releases/download/v2.1.11/zeromq-2.1.11.tar.gz && \
    tar -xvf zeromq-2.1.11.tar.gz && cd zeromq-2.1.11 && \
    ./configure && make && \ 
    make install && sudo ldconfig

RUN luarocks install lua-zmq ZEROMQ_LIBDIR=/usr/local/lib ZEROMQ_INCDIR=/usr/local/include

RUN luarocks install restserver-xavante
RUN luarocks install dkjson

RUN cd ~ && \
    git clone --recursive https://github.com/senisioi/NeuralTextSimplification.git && \
    cd ./NeuralTextSimplification && \
    pip install -r src/requirements.txt && \
    python src/download_models.py ./models

EXPOSE 5556
