#!/bin/zsh -f

# grep -v \# $0 | sed '/^$/d'

# grep -v \# ~/bin/deploy.sh | sed '/^$/d' | awk '{print $1}' > ~/rsync.edis

# grep -v \# ~/bin/deploy.sh | sed -e '/^$/d' > ~/rsync.edis

# IPtables & network
/etc/iptables.save
/etc/ip6tables.save
/etc/network/if-pre-up.d/firewall
/etc/network/interfaces

# OpenVPN
/etc/openvpn/server.conf
/etc/openvpn/easy-rsa/vars

# Exim
/etc/exim4/exim4.conf.template
/etc/default/exim4

# Dovecot
/etc/dovecot/dovecot.conf

/etc/dovecot/conf.d/10-auth.conf
# /etc/dovecot/conf.d/10-director.conf
# /etc/dovecot/conf.d/10-logging.conf
/etc/dovecot/conf.d/10-mail.conf
# /etc/dovecot/conf.d/10-master.conf
/etc/dovecot/conf.d/10-ssl.conf
# /etc/dovecot/conf.d/10-tcpwrapper.conf
# /etc/dovecot/conf.d/15-lda.conf
# /etc/dovecot/conf.d/15-mailboxes.conf
/etc/dovecot/conf.d/20-imap.conf
# /etc/dovecot/conf.d/90-acl.conf
/etc/dovecot/conf.d/90-plugin.conf
# /etc/dovecot/conf.d/90-quota.conf
# /etc/dovecot/conf.d/auth-checkpassword.conf.ext
# /etc/dovecot/conf.d/auth-deny.conf.ext
# /etc/dovecot/conf.d/auth-master.conf.ext
# /etc/dovecot/conf.d/auth-passwdfile.conf.ext
# /etc/dovecot/conf.d/auth-sql.conf.ext
# /etc/dovecot/conf.d/auth-static.conf.ext
# /etc/dovecot/conf.d/auth-system.conf.ext
# /etc/dovecot/conf.d/auth-vpopmail.conf.ext

# SASLAuth

/etc/default/saslauthd

# Spamassassin
/etc/default/spamassassin
/usr/bin/sa-learn-pipe.sh

# SSH
/etc/ssh/sshd_config

# NTP
/etc/ntp.conf

# APT
/etc/apt/sources.list

# Aliases
/etc/aliases

# PAM
/etc/pam.d/su
/etc/pam.d/common-account
/etc/pam.d/common-auth

# SUDO
# /etc/sudoers

# OpenSSL
/usr/lib/ssl/openssl.cnf
/etc/ssl/openssl.cnf

# rsync
# /etc/rsyncd.conf
# /etc/rsyncd.secrets

# rc
/etc/rc.local

# radicale
/etc/radicale/config

# openssl req -newkey rsa:4096 -days 3650 -nodes -out <file> -keyout <file>
