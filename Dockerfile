FROM ubuntu:18.04
MAINTAINER ASCDC <asdc.sinica@gmail.com>

ADD run.sh /script/run.sh
ADD command.sh /script/command.sh

RUN chmod +x /script/*.sh && \
apt-get update -yyq && \
apt-get dist-upgrade -yyq && \
apt-get install -yyq tzdata locales locales-all dumb-init software-properties-common cron mariadb-client-10.1 vim bc jq sshpass git wget curl vim apt-utils sudo language-pack-zh-hant language-pack-zh-hant-base exiftool openssh-server pwgen rsync subversion build-essential && \
ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \
dpkg-reconfigure --frontend noninteractive tzdata && \
echo "locales locales/default_environment_locale select zh_TW.UTF-8" | debconf-set-selections && \
echo "locales locales/locales_to_be_generated multiselect zh_TW.UTF-8 UTF-8" | debconf-set-selections && \
rm -f "/etc/locale.gen" && \
dpkg-reconfigure --frontend noninteractive locales && \
locale-gen en_US.UTF-8 && \
export LANG=zh_TW.UTF-8 && \
export LC_ALL=zh_TW.UTF-8 && \
echo "export LANG=zh_TW.UTF-8" >> ~/.bashrc && \
echo "export LC_ALL=zh_TW.UTF-8" >> ~/.bashrc && \
echo "alias ll='ls -al --color=auto'" >> ~/.bashrc && \
echo "alias ls='ls --color=auto'" >> ~/.bashrc && \
echo "alias grep='grep --color=auto'" >> ~/.bashrc && \
add-apt-repository -y ppa:ondrej/php && \
add-apt-repository -y ppa:mc3man/trusty-media && \
add-apt-repository -y ppa:stebbins/handbrake-releases && \
apt-get update && \
apt-get install -yyq ffmpeg flac shntool imagemagick sox tofrodos unrar-free p7zip-full php7.0-cli php7.0-mysql mediainfo handbrake-cli libxvidcore4 zlib1g-dbg zlib1g-dev ruby-full && \
echo "SHELL=/bin/sh"> /etc/crontab && \
echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin">> /etc/crontab && \
echo "*/1 * * * * root /script/command.sh">> /etc/crontab && \
svn co https://svn.code.sf.net/p/gpac/code/trunk/gpac gpac && cd gpac && \
./configure --disable-opengl --use-js=no --use-ft=no --use-jpeg=no --use-png=no --use-faad=no --use-mad=no --use-xvid=no --use-ffmpeg=no --use-ogg=no --use-vorbis=no --use-theora=no --use-openjpeg=no && make && make install && cp bin/gcc/libgpac.so /usr/lib && \
gem install flvtool2 

WORKDIR /script
ENTRYPOINT ["/script/run.sh"]