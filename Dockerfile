# ------------------------------------------------------------------------------
# Pull base image
FROM fullaxx/ubuntu-desktop
MAINTAINER Brett Kuskie <fullaxx@gmail.com>

# ------------------------------------------------------------------------------
# Set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C
ENV TZ Etc/Zulu
ENV ANACFILE="Anaconda3-2019.10-Linux-x86_64.sh"
ENV CHROMEURL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
ENV CHROMEDEB="/tmp/chrome.deb"
ENV DCURL="https://github.com/docker/compose/releases/download/1.25.4/docker-compose-Linux-x86_64"
ENV VSCODEURL="https://go.microsoft.com/fwlink/?LinkID=760868"
ENV VSCODEDEB="/tmp/vscode.deb"

# ------------------------------------------------------------------------------
# Clean up base and Update apt
RUN rm -rf /app/scripts && apt-get update

# ------------------------------------------------------------------------------
# Install basic dev tools
RUN apt-get install -y apcalc apt-transport-https audacious \
bash-completion bluefish bridge-utils build-essential \
ca-certificates caja cdw cgdb chaosreader cmake colordiff colortail ctags cvs \
ddd docker.io dos2unix doxygen diffstat emacs evince file \
galculator gdb geany gedit gimp git gkrellm gnupg2 \
htop hexcompare hexcurse hexdiff hexedit hexer \
iftop inkscape iperf jupyter-notebook kcachegrind kmod \
less libcurl4 libczmq4 liblog4cpp5v5 libmicrohttpd12 \
libpcap0.8 libprotobuf10 libprotobuf-c1 libssl1.1 \
libwebsockets8 libwebsockets-test-server libwebsockets-test-server-common \
libxml2 libzmq5 libzmq-java lsof man mc medit mosh most \
nedit netcat nload nmap nmapfe nmon openssh-server openssh-client \
p7zip patch parallel psmisc python3.8 rsync \
screen simpleburn software-properties-common sqlite3 subversion sudo swig \
tcpdump terminator terminology tmux tree \
unzip uuid valgrind vim vim-gtk3 vlc wireshark xfe zenmap

# ------------------------------------------------------------------------------
# Install platform tools
RUN apt-get install -y chromium-browser eclipse firefox \
libreoffice maven octave openjdk-11-jdk redis

# ------------------------------------------------------------------------------
# Install Chrome
RUN wget ${CHROMEURL} -O ${CHROMEDEB} && \
dpkg -i ${CHROMEDEB} || (set -e; apt-get update; apt-get install -f -y) && \
rm ${CHROMEDEB}

# ------------------------------------------------------------------------------
# Install VSCode
RUN wget ${VSCODEURL} -O ${VSCODEDEB} && \
dpkg -i ${VSCODEDEB} || (set -e; apt-get update; apt-get install -f -y) && \
rm ${VSCODEDEB}

# ------------------------------------------------------------------------------
# Skipping Anaconda for now ...
# RUN wget https://repo.anaconda.com/archive/${ANACFILE} && \
# chmod +x ${ANACFILE} && \
# ./${ANACFILE} -b && \
# rm ${ANACFILE}

# ------------------------------------------------------------------------------
# Install docker-compose
RUN curl -L ${DCURL} -o /usr/bin/docker-compose

# ------------------------------------------------------------------------------
# Install python libraries
RUN apt-get install -y cython cython3 \
python-hiredis python3-hiredis \
python-mako python3-mako \
python-numpy python3-numpy \
python-pip python3-pip \
python-protobuf python3-protobuf \
python-pymongo python3-pymongo \
python-pyqt5 python3-pyqt5 \
python-redis python3-redis \
python-setuptools python3-setuptools \
python-scipy python3-scipy \
python-six python3-six \
python-virtualenv python3-virtualenv \
python-yaml python3-yaml \
python-zmq python3-zmq

# ------------------------------------------------------------------------------
# Install dev libraries
RUN apt-get install -y libboost-all-dev \
libcurl4-openssl-dev libczmq-dev libgnutls28-dev libhiredis-dev \
liblog4cpp5-dev libmicrohttpd-dev libmongoc-dev libmongodb-java \
libpcap-dev libprotobuf-dev libprotobuf-c-dev libprotobuf-java \
libsodium-dev libsqlite3-dev libssl-dev libwebsockets-dev \
libxml2-dev libzmq3-dev pyqt5-dev uuid-dev

# ------------------------------------------------------------------------------
# Install GNURadio (FIXME)
# RUN mkdir -p /opt/gnuradio && \
# git clone --recursive https://github.com/gnuradio/gnuradio.git && \
# ( cd gnuradio && git checkout maint-3.8 && mkdir build && cd build && \
# cmake -DCMAKE_INSTALL_PREFIX=/opt/gnuradio -DCMAKE_CXX_STANDARD=11 ../ && \
# make install -j `nproc` ) && \
# echo "/opt/gnuradio/lib64" > /etc/ld.so.conf.d/gnuradio.conf && ldconfig && \
# cp -a gnuradio/grc/scripts/gnuradio-companion /opt/gnuradio/bin && \
# echo 'export PATH=$PATH:/opt/gnuradio/bin' > /etc/profile.d/gnuradio.sh && \
# rm -rf gnuradio

# ------------------------------------------------------------------------------
# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# ------------------------------------------------------------------------------
# Install configuration files
COPY bg/* /usr/share/ubuntu-desktop/bg/
COPY conf/autostart conf/menu.xml /usr/share/ubuntu-desktop/openbox/
COPY conf/htoprc /usr/share/ubuntu-desktop/htop/htoprc
COPY conf/xstartup /usr/share/ubuntu-desktop/vnc/

# ------------------------------------------------------------------------------
# Expose ports
EXPOSE 5901

# ------------------------------------------------------------------------------
# Define default command
CMD ["/app/app.sh"]
