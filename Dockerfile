FROM ubuntu:16.04

MAINTAINER "Eugene O'Brien <e.obrien@sportstg.com>"

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    apt-utils \
    libyaml-perl \
    libjson-any-perl \
    libxml-simple-perl \
    libmail-sendmail-perl \
    libdbix-class-schema-loader-perl \
    libdbd-mysql-perl \
    liblog-log4perl-perl \
    build-essential \
    libexpat1-dev \
    libtest-compile-perl \
    libdigest-md5-perl \
    libcache-memcached-fast-perl \
    libnet-telnet-perl \
    perlmagick \
    libxml-dom-perl \
    libjson-perl \
    libdatetime-perl \
    libclass-dbi-perl \
    libcrypt-cbc-perl \
    libdate-simple-perl \
    libsphinx-search-perl \
    libxml-rss-perl \
    libsoap-lite-perl \
    libarchive-zip-perl \
    libsort-versions-perl \
    libcgi-session-perl \
    libwww-mechanize-perl \
    libcaptcha-recaptcha-perl \
    libhtml-scrubber-perl \
    libfrontier-rpc-perl \
    libnet-twitter-perl \
    libgd-perl \
    libdata-random-perl \
    liblog-dispatch-perl \
    libmime-base64-urlsafe-perl \
    libtext-csv-perl \
    libdatetime-format-mysql-perl \
    libmail-rfc822-address-perl \
    libdatetime-format-flexible-perl \
    libmath-round-perl \
    libswitch-perl \
    libdate-range-perl \
    libexcel-writer-xlsx-perl \
    libfile-mimeinfo-perl \
    libcgi-ajax-perl \
    libbarcode-code128-perl \
    libnet-sftp-foreign-perl \
    libtext-aspell-perl \
    libspreadsheet-xlsx-perl \
    libfile-slurp-unicode-perl \
    libhtml-fillinform-perl \
    perl-modules \
    libyaml-syck-perl \
    libcompress-raw-bzip2-perl \
    libcompress-raw-zlib-perl \
    libtest-yaml-perl \
    libtest-fatal-perl \
    libtest-mockobject-perl \
    libarray-utils-perl \
    liburi-fromhash-perl \
    liblwp-useragent-determined-perl \
    libfile-mmagic-perl \
    libfile-which-perl \
    libterm-readkey-perl \
    libhtml-template-perl \
    libunix-configfile-perl \
    libuniversal-can-perl \
    libuniversal-isa-perl \
    libcgi-application-perl \
    libcgi-application-plugin-session-perl \
    libextutils-cbuilder-perl \
    libcrypt-blowfish-perl \
    liblib-abs-perl \
    curl

#removed libmongodb-perl 2016-08-16. Need older version v0.708.0.0.

RUN curl -L http://cpanmin.us | perl - App::cpanminus

RUN cpanm \
    MD5 \
    CHI \
    Beanstalk::Client \
    AWS::S3 \
    Sort::Maker \
    Captcha::reCAPTCHA::V2 \
    Net::Amazon::S3::Policy \
    Digest::SHA1 \
    CGI::Upload
        
#The order of these matter, as Ouch won't successfully test witout Test::Trap
RUN cpanm \
    Test::Trap \
    Ouch

#Facebook at least requires Ouch module to be installed. Make sure these stay correctly ordered.
RUN cpanm \
    Facebook::Graph \
    Net::Twitter::Lite \
    CGI::FileManager

#I can't get these to install with testing on.
#Net::AWS::SES fails on 1 test of 25, for reasons I can't quite figure out
#Forecast::IO expects to be installed interactively and hangs waiting for an API key to be entered
RUN cpanm --notest \
    Net::AWS::SES \
    Forecast::IO

#These are all dependencies of MongoDB
RUN cpanm \
    Config::AutoConf \
    Throwable \
    Safe::Isa \
    Authen::SCRAM::Client \
    DateTime::Tiny \
    Crypt::URandom \
    boolean \
    Syntax::Keyword::Junction \
    syntax

ADD perl_modules/MongoDB-v0.708.0.0.tar.gz /root/

RUN cd /root/MongoDB-v0.708.0.0 && \
    cpanm . && \
    rm -rf /root/MongoDB-v0.708.0.0

RUN rm -rf /var/lib/apt/lists/*

RUN rm -rf $HOME/.cpan* \
    /tmp/cpan_install_*.txt

