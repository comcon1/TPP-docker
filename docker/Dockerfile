FROM ubuntu:20.04

ENV ZIPF=tpp-git-v1.0-r
ENV TZ=Europe/Moscow
COPY ${ZIPF}.zip /tmp/

RUN echo $TZ && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update -y && \
    apt-get install -y tzdata wget unzip cmake build-essential automake && \
    cd && \
    wget https://github.com/openbabel/openbabel/archive/refs/tags/openbabel-2-4-0.zip && \
    unzip openbabel-2-4-0.zip && \
    cd openbabel-openbabel-2-4-0 && \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local/openbabel-240 \
          -DBUILD_GUI=OFF -DENABLE_TESTS=OFF -DWITH_INCHI=OFF .. && \
    make -j4 && make install && \
    ls -R /usr/local/openbabel-240 && \
    cd && rm -fr ~/openbabel-openbabel-2-4-0 && \
    \
    unzip /tmp/${ZIPF}.zip -d /root/ && rm /tmp/*.zip && \
    cd /root/${ZIPF} && \
    apt-get install -y libmysqlclient21 libmysql++3v5 && \
    apt-get install -y libboost-thread1.71.0 libboost-filesystem1.71.0 \
    	 	   libboost-program-options1.71.0 libboost-regex1.71.0 \
    		   libboost-log1.71.0 && \
    apt-get install -y libmysql++-dev && \
    apt-get install -y libboost1.71-dev libboost-thread1.71-dev libboost-filesystem1.71-dev \
    		   libboost-program-options1.71-dev libboost-regex1.71-dev libboost-log1.71-dev && \
    ./bootstrap.sh && \
    OPENBABEL_CFLAGS=-I/usr/local/openbabel-240/include/openbabel-2.0/ \
     OPENBABEL_LIBS=-Wl,-rpath=/usr/local/openbabel-240/lib \
     LDFLAGS=-L/usr/local/openbabel-240/lib/ ./configure --enable-debugmode && \
    make -j4 && make install && \
    cd && rm -fr /root/${ZIPF} && \
    apt-get remove -y --purge unzip wget cmake automake build-essential libmysql++-dev && \
    apt-get remove -y --purge libboost1.71-dev libboost-thread1.71-dev libboost-filesystem1.71-dev \
    		   libboost-program-options1.71-dev libboost-regex1.71-dev libboost-log1.71-dev && \
    apt-get -y autoremove --purge && apt-get clean && apt-get purge && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /work

COPY runtppmktop.sh /usr/bin/

VOLUME ["/work"]

WORKDIR /work

CMD ["/bin/bash"]

# @TODO: remove unused modules!
# (still not tested)
# 
#    cd /usr/local/openbabel-240/lib/openbabel/2.4.0 && \
#    mkdir ~/tmp && mv *format.so ~/tmp && \
#    mv ~/tmp/pdbformat.so . && \
#    mv ~/tmp/groformat.so . && \
#    mv ~/tmp/gromos96format.so . && \
#    mv ~/tmp/xyzformat.so . && \
#    rm -fr ~/tmp && \ 

