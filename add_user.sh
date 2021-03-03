#!/bin/bash

USER=$1
ID=$2
STATUS=$3

if [ -z $STATUS ] || [ $STATUS = "normal" ]
then

  if [ -d /media/User/$USER ]
  then
    useradd \
    --no-create-home \
    --no-user-group \
    --gid staff \
    --uid $ID \
    --home /media/User/$USER \
    --groups staff,root,sudo \
    $USER &&
    echo "$USER:$USER" | chpasswd
  else
    useradd \
    --create-home \
    --no-user-group \
    --gid staff \
    --uid $ID \
    --home /media/User/$USER \
    --groups staff,root,sudo \
    $USER &&
    echo "$USER:$USER" | chpasswd
  fi

else

  if [ -d /media/User/$USER ]
  then
    useradd \
    --no-create-home \
    --no-user-group \
    --gid staff \
    --uid $ID \
    --home /media/User/$USER \
    --groups staff \
    $USER &&
    echo "$USER:$USER" | chpasswd
  else
    useradd \
    --create-home \
    --no-user-group \
    --gid staff \
    --uid $ID \
    --home /media/User/$USER \
    --groups staff \
    $USER &&
    echo "$USER:$USER" | chpasswd
  fi
    
fi

[ -f /media/User/$USER/.bash_profile ] || echo '
# .bash_profile

umask 0002

### ================================================================================================
### Set locales
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER="en_US.UTF-8"
export LC_NAME="en_US.UTF-8"
export LC_ADDRESS="en_US.UTF-8"
export LC_TELEPHONE="en_US.UTF-8"
export LC_MEASUREMENT="en_US.UTF-8"
export LC_IDENTIFICATION="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"


### ================================================================================================
### Set prompt
export PS1="________________________________________________________________________________\n| \w @ \H (\u) \n| > "
export PS2="| > "
export EDITOR=/usr/bin/nano
export BLOCKSIZE=1k


### ================================================================================================
### Set aliases
alias R="R --no-save --no-restore-data --no-init-file"
alias Rscript="Rscript --no-init-file"

alias cp="cp -iv"                           # Nouvelle copie
alias mv="mv -iv"                           # Nouveau move
alias mkdir="mkdir -pv"                     # Nouvelle création de dossier
alias ll="ls -FlAhp --color=auto"           # Affiche fichier, dossier, et fichiers cachés
alias l="ls -Flhp --color=auto"             # Affiche fichier et dossier
alias ls="ls --color=auto" 
cd() { builtin cd "$@"; ll; }               # Changement de dossier
' > /media/User/$USER/.bash_profile && chown -R $USER:staff /media/User/$USER

