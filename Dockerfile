FROM debian:buster

MAINTAINER João Pedro Menegali Salvan Bitencourt (joao.ms@aluno.ifsc.edu.br)

RUN export DEBIAN_FRONTEND=noninteractive && \
    \
    apt update && \
    apt -y -q upgrade && \
    apt -y -q install apt-utils && \
    apt -y -q install wget make xmlstarlet libsqlite3-0 libjansson4 liburiparser1 libedit2 libcurl4 libgmime-2.6-0 libsdl1.2debian libspeex1 libsnmp30 libosptk4 libcodec2-0.8.1 libavahi-client3 libpq5 libspandsp2 libjack0 libradcli4 libneon27 libfftw3-3 libunbound8 libsybdb5 libodbc1 liblua5.2-0 libsrtp2-1 libcpg4 libbluetooth3 libiksemel3 libvpb1 libgsm1 libspeexdsp1 libresample1 libvorbisfile3 libical3 libcfg7 procps mpg123 && \
    wget https://jpmsb.sj.ifsc.edu.br/asterisk.tar.gz -O /asterisk.tar.gz && \
    tar -xvf /asterisk.tar.gz && \
    make install -C /asterisk-16.2.1 && \
    make samples -C /asterisk-16.2.1 && \
    rm -r /asterisk* && \
    echo "noload => res_mwi_external.so" >> /etc/asterisk/modules.conf && \
    \
    # Ajustes no fuso para BRT
    echo "America/Sao_Paulo" > /etc/timezone && \
    rm -r /etc/localtime && \
    ln -snf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    \
    # Fazendo uma limpeza
    apt clean && \
    apt clean cache && \
    unset DEBIAN_FRONTEND && \
    rm -rf /var/lib/apt/lists/* /tmp/* /root/.bash_history

ENTRYPOINT asterisk -vvvvvvf
