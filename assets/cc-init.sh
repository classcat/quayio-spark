#!/bin/bash

########################################################################
# ClassCat/Spark Asset files
# Copyright (C) 2015 ClassCat Co.,Ltd. All rights reserved.
########################################################################

#--- HISTORY -----------------------------------------------------------
# 05-sep-15 : ipython env added.
# 05-sep-15 : fixed.
#-----------------------------------------------------------------------


######################
### INITIALIZATION ###
######################

function init () {
  echo "ClassCat Info >> initialization code for ClassCat/Spark"
  echo "Copyright (C) 2015 ClassCat Co.,Ltd. All rights reserved."
  echo ""
}


############
### SSHD ###
############

function change_root_password() {
  if [ -z "${ROOT_PASSWORD}" ]; then
    echo "ClassCat Warning >> No ROOT_PASSWORD specified."
  else
    echo -e "root:${ROOT_PASSWORD}" | chpasswd
    # echo -e "${password}\n${password}" | passwd root
  fi
}


function put_public_key() {
  if [ -z "$SSH_PUBLIC_KEY" ]; then
    echo "ClassCat Warning >> No SSH_PUBLIC_KEY specified."
  else
    mkdir -p /root/.ssh
    chmod 0700 /root/.ssh
    echo "${SSH_PUBLIC_KEY}" > /root/.ssh/authorized_keys
  fi
}


################
### NOTEBOOK ###
################

function proc_notebook () {
  local PW_SHA1=`/opt/pwgen.py ${NOTEBOOK_PASSWD}`

  sed -i.bak -e "s/^c\.NotebookApp\.password\s*= \s*.*/c.NotebookApp.password = u'${PW_SHA1}'/" \
    /root/.ipython/profile_ccnb/ipython_notebook_config.py

  echo 'export IPYTHON=1' > /root/.bash_profile
  echo 'export IPYTHON_OPTS="notebook --profile=ccnb"' >> /root/.bash_profile
}


##################
### SUPERVISOR ###
##################
# See http://docs.docker.com/articles/using_supervisord/

function proc_supervisor () {
  cat > /etc/supervisor/conf.d/supervisord.conf <<EOF
[program:ssh]
command=/usr/sbin/sshd -D

#[program:rsyslog]
#command=/usr/sbin/rsyslogd -n

[program:pyspark]
command=/usr/local/spark/bin/pyspark
environment=IPYTHON=1,IPYTHON_OPTS="notebook --profile=ccnb"
EOF
}



### ENTRY POINT ###

init 
change_root_password
put_public_key
proc_notebook
proc_supervisor

exit 0


### End of Script ###

