#!/bin/bash -x
# $Id: build-httpd2.sh 2265 2006-10-26 17:17:22Z marcus.ferreira $
#
# Apache 2.2.3 - RH ES 4
# Ago/2006
#


# export BERKELEY_DB="/usr/local/svn/BerkeleyDB"
# export LD_LIBRARY_PATH=$BERKELEY_DB/lib

DIR=./httpd-2.2.4
cd $DIR

# CC="gcc.orig -I${PREFIX}/apache/include/apr-1 -I${PREFIX}/apache/include/"
# LDFLAGS="-lintl -L${PREFIX}/lib -L${PREFIX}/apache/lib"

./configure     \
    --prefix=$PREFIX/apache             \
    --enable-layout=Apache              \
    --enable-shared                     \
    --with-ssl                          \
    --enable-mods-shared="all dav_lock proxy cgid suexec"    \
    2>&1 | tee configure.my.all.log

#   --enable-mods-shared="all dav_lock ldap proxy cgid suexec"    \
#   --with-apr=$PREFIX/apache           \
#   --with-apr-util=$PREFIX/apache      \


    make         | tee make.my.log          && \
    make install | tee make.my.install.log


