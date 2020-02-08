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
# Install basic tools
RUN apt-get install -y apcalc apt-transport-https bash-completion build-essential \
bridge-utils ca-certificates caja cdw cgdb cmake colordiff colortail curl \
dos2unix diffstat evince file galculator gdb gedit gimp git gkrellm gnupg2 \
htop hexcompare hexcurse hexdiff hexedit hexer iftop inkscape iperf less \
libcurl4 libczmq4 libmicrohttpd12 libpcap0.8 libssl1.1 libxml2 libzmq5 libzmq-java \
lsof man mc mosh most nano nedit netcat nload nmon openssh-server openssh-client \
patch parallel psmisc python3.8 rsync \
simpleburn software-properties-common screen sudo sqlite3 \
terminator terminology tmux tree tzdata wget unzip xfe xterm

# ------------------------------------------------------------------------------
# Install platform tools
RUN apt-get install -y chromium-browser firefox \
libreoffice maven eclipse octave openjdk-11-jdk redis

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
# Install Anaconda
#RUN wget https://repo.anaconda.com/archive/${ANACFILE} && \
#chmod +x ${ANACFILE} && \
#./${ANACFILE} -b && \
#rm ${ANACFILE}

# ------------------------------------------------------------------------------
# Install docker-compose
RUN curl -L ${DCURL} -o /usr/bin/docker-compose

# ------------------------------------------------------------------------------
# Install python libraries
RUN apt-get install -y cython cython3 \
python-hiredis python3-hiredis python-redis python3-redis \
python-mako python3-mako \
python-numpy python3-numpy \
python-pip python3-pip \
python-pyqt5 python3-pyqt5 \
python-six python3-six \
python-virtualenv python3-virtualenv \
python-yaml python3-yaml \
python-zmq python3-zmq

# ------------------------------------------------------------------------------
# Install dev tools
RUN apt-get install -y audacious bluefish chaosreader cmake ctags cvs \
ddd docker.io doxygen emacs geany jupyter-notebook kcachegrind kmod \
libboost-all-dev liblog4cpp5v5 medit nmap nmapfe subversion swig tcpdump \
uuid valgrind vim vim-gtk3 wireshark zenmap

# ------------------------------------------------------------------------------
# Install dev libraries
RUN apt-get install -y libczmq-dev libzmq3-dev \
libcurl4-openssl-dev libhiredis-dev libmicrohttpd-dev libpcap-dev \
libsqlite3-dev libssl-dev libxml2-dev liblog4cpp5-dev pyqt5-dev uuid-dev

# ------------------------------------------------------------------------------
# Install GNURadio (THIS DOES NOT WORK YET)
#RUN git clone --recursive https://github.com/gnuradio/gnuradio.git && \
#mkdir -p /opt/gnuradio && \
#(cd gnuradio && git checkout maint-3.8 && sed -i 's/-std=c++${CMAKE_CXX_STANDARD}/-std=c++11/' CMakeLists.txt && mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/opt/gnuradio ../ && make install -j `nproc`) && \
#echo "/opt/gnuradio/lib64" > /etc/ld.so.conf.d/gnuradio.conf && ldconfig && \
#cp -a /gnuradio/grc/scripts/gnuradio-companion /opt/gnuradio/bin && \
#echo 'export PATH=$PATH:/opt/gnuradio/bin' > /etc/profile.d/gnuradio.sh && \
#rm -rf gnuradio

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
