FROM library/debian:buster


ENV UMR1283_VERSION=1.2.1
ENV R_VERSION=4.1.1
ENV RSTUDIO_VERSION=1.4.1717
ENV PANDOC_TEMPLATES_VERSION=2.14
ENV BCFTOOLS_VERSION=1.13
ENV S6_VERSION=2.2.0.3
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2


## Set locales to en_US
RUN apt-get update \
  && apt-get install -y --no-install-recommends locales \
  && sed -i '/^#.* en_US.* /s/^#//' /etc/locale.gen \
  && sed -i '/^#.* en_GB.* /s/^#//' /etc/locale.gen \
  && locale-gen en_GB.UTF-8 \
  && locale-gen en_US.UTF-8 \
  && /usr/sbin/update-locale LANG="en_GB.UTF-8" \
  && /usr/sbin/update-locale LANGUAGE="en_GB.UTF-8" \
  && /usr/sbin/update-locale LC_CTYPE="en_GB.UTF-8" \
  && /usr/sbin/update-locale LC_NUMERIC="en_GB.UTF-8" \
  && /usr/sbin/update-locale LC_TIME="en_GB.UTF-8" \
  && /usr/sbin/update-locale LC_COLLATE="en_GB.UTF-8" \
  && /usr/sbin/update-locale LC_MONETARY="en_GB.UTF-8" \
  && /usr/sbin/update-locale LC_MESSAGES="en_GB.UTF-8" \
  && /usr/sbin/update-locale LC_PAPER="en_GB.UTF-8" \
  && /usr/sbin/update-locale LC_NAME="en_GB.UTF-8" \
  && /usr/sbin/update-locale LC_ADDRESS="en_GB.UTF-8" \
  && /usr/sbin/update-locale LC_TELEPHONE="en_GB.UTF-8" \
  && /usr/sbin/update-locale LC_MEASUREMENT="en_GB.UTF-8" \
  && /usr/sbin/update-locale LC_IDENTIFICATION="en_GB.UTF-8" \
  && /usr/sbin/update-locale LC_ALL="en_GB.UTF-8"


## Set environment variable for path and locales
ENV PATH=/usr/lib/rstudio-server/bin:$PATH

ENV LC_ALL=en_GB.UTF-8
ENV LANGUAGE=en_GB.UTF-8
ENV LANG=en_GB.UTF-8
ENV LC_COLLATE=en_GB.UTF-8


## Install libraries
RUN apt-get update \
  && apt-get install -y --no-install-recommends dialog apt-utils \
  && apt-get install -y --no-install-recommends \
    autoconf \ 
    automake \ 
    bash-completion \ 
    build-essential \ 
    ca-certificates \ 
    cargo \ 
    curl \ 
    default-jdk \ 
    fastqtl \ 
    ffmpeg \ 
    file \ 
    fontconfig \
    fonts-texgyre \ 
    g++ \ 
    gdebi \
    gfortran \ 
    git \ 
    gsfonts \ 
    htop \ 
    libapparmor1 \ 
    libavfilter-dev \ 
    libblas-dev \ 
    libbz2-1.0 \ 
    libbz2-dev \ 
    libcairo2-dev \ 
    libclang-dev \ 
    libcurl4-openssl-dev \ 
    libedit2 \ 
    libfreetype6-dev \
    libfribidi-dev \
    libgc1c2 \ 
    libgdal-dev \ 
    libgit2-dev \
    libgsl-dev \ 
    libharfbuzz-dev \
    libicu-dev \ 
    libio-socket-ssl-perl \ 
    libjpeg-dev \ 
    libjpeg62-turbo \ 
    libleptonica-dev \
    liblzma-dev \ 
    liblzma5 \ 
    libmagick++-dev \ 
    libmpfr-dev \
    libobjc4 \ 
    libopenblas-dev \ 
    libopenmpi-dev \ 
    libpango1.0-dev \ 
    libpangocairo-1.0-0 \ 
    libpcre2-dev \
    libpcre3-dev \ 
    libpng-dev \ 
    libpng16-16 \ 
    libpoppler-cpp-dev \
    libreadline-dev \ 
    libreadline7 \ 
    librsvg2-dev \ 
    libsasl2-dev \ 
    libsodium-dev \
    libssl-dev \ 
    libssh2-1-dev \
    libtesseract-dev \ 
    libtiff5-dev \ 
    libudunits2-dev \ 
    libv8-dev \ 
    libx11-dev \ 
    libxml2-dev \ 
    libxt-dev \
    libzmq3-dev \
    lsb-release \ 
    make \ 
    man-db \ 
    multiarch-support \ 
    nano \
    openssh-client \ 
    pandoc \ 
    pandoc-citeproc \ 
    perl \ 
    procps \ 
    psmisc \ 
    python-setuptools \ 
    qpdf \ 
    sudo \ 
    tar \ 
    tcl8.6-dev \ 
    tesseract-ocr-eng \ 
    texinfo \ 
    tk8.6-dev \ 
    unzip \ 
    wget \ 
    x11proto-core-dev \ 
    xauth \ 
    xfonts-base \ 
    xtail \
    xvfb \ 
    zip \ 
    zlib1g \ 
    zlib1g-dev \
  && apt-get autoremove -y \
  && apt-get autoclean -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/ \
  && rm -rf /tmp/*


## Configure git
RUN git config --system core.sharedRepository 0775 \
  && git config --system credential.helper "cache --timeout=3600" \
  && git config --system push.default simple \
  && git config --system core.editor "nano -w" \
  && git config --system color.ui auto 
  

## Set default umask
RUN echo "\n\umask 0002\n" >> /etc/profile


## Install libraries for databases
# https://dev.mysql.com/downloads/connector/odbc/
# https://dev.mysql.com/get/Downloads/Connector-ODBC/8.0/mysql-connector-odbc-setup_8.0.22-1debian10_amd64.deb
RUN apt-get update \
  && apt-get install -y tdsodbc odbc-postgresql libsqliteodbc unixodbc unixodbc-dev \
  && wget -q -P /tmp/ https://dev.mysql.com/get/Downloads/Connector-ODBC/8.0/mysql-connector-odbc-8.0.19-linux-debian10-x86-64bit.tar.gz \
  && tar -C /tmp/ -xvf /tmp/mysql-connector-odbc-8.0.19-linux-debian10-x86-64bit.tar.gz \
  && cp /tmp/mysql-connector-odbc-8.0.19-linux-debian10-x86-64bit/bin/* /usr/local/bin \
  && cp /tmp/mysql-connector-odbc-8.0.19-linux-debian10-x86-64bit/lib/* /usr/local/lib \
  && myodbc-installer -a -d -n "MySQL ODBC 8.0 Driver" -t "Driver=/usr/local/lib/libmyodbc8w.so" \
  && rm -rf /tmp/*


## Install BCFTOOLS
RUN wget -q -P /tmp/ https://github.com/samtools/bcftools/releases/download/${BCFTOOLS_VERSION}/bcftools-${BCFTOOLS_VERSION}.tar.bz2 \
  && tar -C /tmp/ -xjf /tmp/bcftools-${BCFTOOLS_VERSION}.tar.bz2 \
  && cd /tmp/bcftools-${BCFTOOLS_VERSION} \
  && autoreconf -i \
  && ./configure --prefix=/usr \
  && make \
  && make install \
  && rm -rf /tmp/bcftools-${BCFTOOLS_VERSION}


## Install HTSLIB
RUN wget -q -P /tmp/ https://github.com/samtools/htslib/releases/download/${BCFTOOLS_VERSION}/htslib-${BCFTOOLS_VERSION}.tar.bz2 \
  && tar -C /tmp/ -xjf /tmp/htslib-${BCFTOOLS_VERSION}.tar.bz2 \
  && cd /tmp/htslib-${BCFTOOLS_VERSION} \
  && autoreconf -i \
  && ./configure --prefix=/usr \
  && make \
  && make install \
  && rm -rf /tmp/htslib-${BCFTOOLS_VERSION}
  
  
## Install PLINK / PLINK1.9
RUN apt-get update && apt-get install -y --no-install-recommends plink plink1.9


## Install VCFTOOLS
RUN apt-get update && apt-get install -y --no-install-recommends vcftools

## Add CrossMap
RUN apt-get update \
  && apt-get install -y --no-install-recommends python3.7-dev python3.7-venv python3-pip \
  && python3.7 -m pip install setuptools \
  && python3.7 -m pip install wheel \
  && python3.7 -m pip install CrossMap \
  && python3.7 -m pip install CrossMap --upgrade
  
  
## Add Microsoft Fonts
RUN apt-get update \
  && apt-get install libmspack0 cabextract \
  && wget -q -P /tmp/ http://ftp.br.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.7_all.deb \
  && dpkg -i /tmp/ttf-mscorefonts-installer_3.7_all.deb \
  && fc-cache -fv \
  && rm /tmp/ttf-mscorefonts-installer_3.7_all.deb
  

## Add fexsend client
COPY fexsend /usr/local/bin/fexsend
RUN chmod 755 /usr/local/bin/fexsend


## Install R
RUN wget -q -P /tmp/ https://cran.r-project.org/src/base/R-${R_VERSION%%.*}/R-${R_VERSION}.tar.gz \
  ## Extract source code
  && tar -C /tmp/ -zxvf /tmp/R-${R_VERSION}.tar.gz \
  && cd /tmp/R-${R_VERSION} \
  ## Set compiler flags
  && R_PAPERSIZE=a4 \
    R_BATCHSAVE="--no-save --no-restore" \
    R_BROWSER=xdg-open \
    PAGER=/usr/bin/pager \
    PERL=/usr/bin/perl \
    R_UNZIPCMD=/usr/bin/unzip \
    R_ZIPCMD=/usr/bin/zip \
    R_PRINTCMD=/usr/bin/lpr \
    LIBnn=lib \
    AWK=/usr/bin/awk \
    CFLAGS="-g -O2 -Wall -pedantic -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2" \
    CXXFLAGS="-g -O2 -Wall -pedantic -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2" \
    CXX98FLAGS="-g -O2 -Wall -pedantic -fstack-protector-strong -D_FORTIFY_SOURCE=2" \
    CXX11FLAGS="-g -O2 -Wall -pedantic -fstack-protector-strong -D_FORTIFY_SOURCE=2" \
    CXX14FLAGS="-g -O2 -Wall -pedantic -fstack-protector-strong -D_FORTIFY_SOURCE=2" \
  ## Configure options
  ./configure --enable-R-shlib \
              --enable-memory-profiling \
              --with-readline \
              --with-blas \
              --with-tcltk \
              --disable-nls \
              --with-recommended-packages \
  ## Build and install
  && make \
  && make install \
  && mkdir -p -m 775 /usr/local/lib/R/site-library \
  && chown root:staff /usr/local/lib/R/site-library \
  && echo "options(repos = c(CRAN = 'https://cloud.r-project.org/'), download.file.method = 'libcurl') \
    \nSys.umask('0002') \
    \n" >> /usr/local/lib/R/etc/Rprofile.site \
  && echo "R_LIBS=\${R_LIBS-'/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library'} \
    \nLANGUAGE='en_GB.UTF-8' \
    \nR_LIBS_USER=~/R/library \
    \nTZ='Etc/UTC' \
    \nR_MAX_NUM_DLLS=300 \
    \nRENV_PATHS_CACHE=/renv_cache \
    " >> /usr/local/lib/R/etc/Renviron \
  && rm -rf /tmp/*


## Install Rstudio server
RUN wget -q -P /tmp/ https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64/rstudio-server-${RSTUDIO_VERSION}-amd64.deb \
  && dpkg -i /tmp/rstudio-server-*-amd64.deb \
  ## Symlink pandoc & standard pandoc templates for use system-wide
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin \
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin \
  && git clone --recursive --branch ${PANDOC_TEMPLATES_VERSION} https://github.com/jgm/pandoc-templates \
  && mkdir -p /opt/pandoc/templates \
  && cp -r pandoc-templates*/* /opt/pandoc/templates && rm -rf pandoc-templates* \
  && mkdir /root/.pandoc && ln -s /opt/pandoc/templates /root/.pandoc/templates \
  ## RStudio wants an /etc/R, will populate from $R_HOME/etc
  && mkdir -p /etc/R \
  ## Write config files in $R_HOME/etc
  && echo '\n\
    \n# Configure httr to perform out-of-band authentication if HTTR_LOCALHOST \
    \n# is not set since a redirect to localhost may not work depending upon \
    \n# where this Docker container is running. \
    \nif(is.na(Sys.getenv("HTTR_LOCALHOST", unset=NA))) { \
    \n  options(httr_oob_default = TRUE) \
    \n}' >> /usr/local/lib/R/etc/Rprofile.site \
  && echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron \
  ## Prevent rstudio from deciding to use /usr/bin/R if a user apt-get installs a package
  && echo 'rsession-which-r=/usr/local/bin/R' >> /etc/rstudio/rserver.conf \
  ## use more robust file locking to avoid errors when using shared volumes:
  && echo 'lock-type=advisory' >> /etc/rstudio/file-locks \
  ## Set up S6 init system
  && wget -q -P /tmp/ https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz \
  && tar hzxf /tmp/s6-overlay-amd64.tar.gz -C / --exclude=usr/bin/execlineb \
  && tar hzxf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin/execlineb && $_clean \
  && mkdir -p /etc/services.d/rstudio \
  && echo '#!/usr/bin/with-contenv bash \
    \n## load /etc/environment vars first: \
    \n for line in $( cat /etc/environment ) ; do export $line ; done \
    \n exec /usr/lib/rstudio-server/bin/rserver --server-daemonize 0' \
    > /etc/services.d/rstudio/run \
  && echo '#!/bin/bash \
    \n rstudio-server stop' \
    > /etc/services.d/rstudio/finish \
  && usermod -g staff rstudio-server \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && rm -rf /tmp/*
  
  
## Install R packages
RUN Rscript \
  -e 'utils::install.packages("pak", repos = "https://r-lib.github.io/p/pak/dev/")' \
  -e 'pak::pak_setup()' \
  -e 'pak::pkg_install(c( \
    "udunits2", \
    "units", \
    "devtools", \
    "usethis", \
    "here", \
    "renv", \
    "ragg", \
    "svglite", \
    "rhub", \
    "rsconnect", \
    "reprex", \
    "palmerpenguins", \
    "data.table", \
    "R.utils", \
    "bit64", \
    "tidyverse", \
    "shiny", \
    "tinytex", \
    "gt", \
    "styler", \
    "miniUI", \
    "prompt", \
    "gert", \
    ifelse( \
      test = grepl("\\.9000", Sys.getenv("UMR1283_VERSION")), \
      yes = "umr1283/umr1283", \
      no = paste0("umr1283/umr1283@v", Sys.getenv("UMR1283_VERSION")) \
    ) \
  ))' \
  -e 'pak::pak_cleanup(force = TRUE)'


## Clean up install
RUN apt-get autoremove -y \
  && apt-get autoclean -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/ \
  && rm -rf /tmp/*
  

## Rstudio templates
COPY rstudio-prefs.json /etc/rstudio/rstudio-prefs.json
RUN mkdir /etc/rstudio/templates/
COPY default.R /etc/rstudio/templates/default.R


## Bash tools script
COPY add_user.sh /add_user.sh
RUN chmod 755 /add_user.sh


EXPOSE 8787


COPY boot.sh /boot.sh
RUN chmod 755 boot.sh


CMD ["/boot.sh"]
