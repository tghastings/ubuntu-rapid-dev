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
ENV VSCODEURL="https://update.code.visualstudio.com/1.43.2/linux-deb-x64/stable"
ENV VSCODEDEB="/tmp/vscode.deb"

# ------------------------------------------------------------------------------
# Clean up base and Update apt
RUN rm -rf /app/scripts && apt update

# ------------------------------------------------------------------------------
# Install basic dev tools
RUN apt install -y apcalc apt-transport-https astyle audacious \
bash-completion bluefish bridge-utils build-essential \
caja cdw cgdb chaosreader cmake colordiff colortail ctags cvs \
ddd docker.io dos2unix doxygen diffstat emacs evince file \
galculator gdb geany gedit gimp git gkrellm gnupg2 \
htop hexcompare hexcurse hexdiff hexedit hexer hping3 \
iftop inetutils-ping inkscape iperf \
jupyter-notebook kcachegrind keepnote kmod \
less libcurl4 libczmq4 liblog4cpp5v5 libmicrohttpd12 \
libpcap0.8 libprotobuf10 libprotobuf-c1 libssl1.1 \
libwebsockets8 libwebsockets-test-server \
libxml2 libzmq5 libzmq-java lsof man mc medit mosh most \
nedit netcat net-tools nload nmap nmapfe nmon openssh-server openssh-client \
p7zip patch parallel psmisc python3.8 python3.8-venv rsync \
screen simpleburn software-properties-common sqlite3 subversion sudo swig \
tcpdump terminator terminology tmux tree \
unzip uuid valgrind vim vim-gtk3 vlc wireshark xfe zenmap

# Install Nvidia and Cuda
# You will need to get the cuda and nvidia installers into the container, run the install, and then remove the installers. 
# This is to keep the size of the docker container down to ~3.6 GB when compressed.
RUN wget http://us.download.nvidia.com/XFree86/Linux-x86_64/418.88/NVIDIA-Linux-x86_64-418.88.run && \
    wget https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux && \
    chmod +x cuda_10.0.130_410.48_linux && ./cuda_10.0.130_410.48_linux --toolkit --toolkitpath=/opt/cuda --silent --override --no-opengl-libs && \
    chmod +x NVIDIA-Linux-x86_64-418.88.run; ./NVIDIA-Linux-x86_64-418.88.run -s --no-kernel-module --no-opengl-files && \
    rm -rf NVIDIA-Linux-x86_64-418.88.run && \
    rm -rf cuda_10.0.130_410.48_linux
# ------------------------------------------------------------------------------

# Install platform tools
RUN apt install -y chromium-browser eclipse firefox \
libreoffice maven octave openjdk-11-jdk redis

# ------------------------------------------------------------------------------
# Install Chrome
RUN wget ${CHROMEURL} -O ${CHROMEDEB} && \
dpkg -i ${CHROMEDEB} || (set -e; apt update; apt install -f -y) && \
rm ${CHROMEDEB}

# ------------------------------------------------------------------------------
# Install VSCode
RUN wget ${VSCODEURL} -O ${VSCODEDEB} && \
dpkg -i ${VSCODEDEB} || (set -e; apt update; apt install -f -y) && \
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
RUN apt install -y cython cython3 \
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
RUN apt install -y libboost-all-dev \
libcurl4-openssl-dev libczmq-dev libgnutls28-dev libhiredis-dev \
liblog4cpp5-dev libmicrohttpd-dev libmongoc-dev libmongodb-java \
libpcap-dev libprotobuf-dev libprotobuf-c-dev libprotobuf-java \
libsodium-dev libsqlite3-dev libssl-dev libwebsockets-dev \
libxml2-dev libzmq3-dev python3-dev python3.8-dev pyqt5-dev uuid-dev

# ------------------------------------------------------------------------------
# Install JAVA libraries
RUN apt install -y netbeans

# ------------------------------------------------------------------------------
# Install RUBY libraries
RUN apt install -y ruby

# ------------------------------------------------------------------------------
# Install GNURadio
RUN add-apt-repository ppa:gnuradio/gnuradio-releases && \
apt update && apt -y install gnuradio

# ------------------------------------------------------------------------------
# Clean up
RUN apt clean && rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# ------------------------------------------------------------------------------
# Install configuration files
COPY bg/* /usr/share/ubuntu-desktop/bg/
COPY conf/autostart conf/menu.xml /usr/share/ubuntu-desktop/openbox/
COPY conf/htoprc /usr/share/ubuntu-desktop/htop/htoprc
COPY conf/xstartup /usr/share/ubuntu-desktop/vnc/
COPY scripts/* /app/scripts/

# ------------------------------------------------------------------------------
# Expose ports for tigervnc and jupyter notebook
EXPOSE 5901
EXPOSE 8888

# ------------------------------------------------------------------------------
# Define default command
CMD ["/app/app.sh"]
