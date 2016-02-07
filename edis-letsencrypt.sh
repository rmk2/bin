#!/bin/bash

set -e

DOMAIN=""

BIN_DIR="/home/ryko/.local/share/letsencrypt/bin"
SOURCE_DIR="/etc/letsencrypt/live"
SERVER_DIR="/var/www/servers"

EMAIL="mail@rmk2.org"

DOMAIN_LIST="eve.rmk2.org imap.rmk2.org smtp.rmk2.org f.rmk2.org p.rmk2.org"

while getopts :d:e: OPT; do
    case $OPT in
	d|+d)
	    DOMAIN_LIST="$OPTARG"
	    ;;
	e|+e)
	    EMAIL="$OPTARG"
	    ;;
	*)
	    echo "usage: ${0##*/} [+-d ARG] [+-e ARG} [--] ARGS..."
	    exit 2
    esac
done
shift $(( OPTIND - 1 ))
OPTIND=1

echo
echo "> Email address: $EMAIL"
echo "> Renewing the following domains: $DOMAIN_LIST"

for i in $DOMAIN_LIST; do
    DOMAIN=$i

    echo "-------------"
    echo "> $DOMAIN"
    echo "-------------"
    
    case $i in
	"eve.rmk2.org" | "p.rmk2.org" | "f.rmk2.org")

	    sudo $BIN_DIR/letsencrypt auth --renew-by-default --email $EMAIL -d $DOMAIN -w $SERVER_DIR/$DOMAIN/pages

	    LIGHTTPD_DIR="/etc/lighttpd"

	    # Combine key and chain for lighttpd
	    echo "...concatenating files"
	    sudo cat $SOURCE_DIR/$DOMAIN/cert.pem $SOURCE_DIR/$DOMAIN/privkey.pem | sudo tee $LIGHTTPD_DIR/ssl/$DOMAIN/server.pem &> /dev/null

	    if [ ! -h "$LIGHTTPD_DIR/ssl/$DOMAIN/cert.pem" ]; then
		sudo ln -sf $SOURCE_DIR/$DOMAIN/cert.pem $LIGHTTPD_DIR/ssl/$DOMAIN/
	    fi

	    if [ ! -h "$LIGHTTPD_DIR/ssl/$DOMAIN/chain.pem" ]; then
		sudo ln -sf $SOURCE_DIR/$DOMAIN/chain.pem $LIGHTTPD_DIR/ssl/$DOMAIN/
	    fi
	    
	    ;;
	"smtp.rmk2.org")

	    sudo $BIN_DIR/letsencrypt auth --renew-by-default --email $EMAIL -d $DOMAIN -w $SERVER_DIR/eve.rmk2.org/pages

	    EXIM_DIR="/etc/exim4"
	    
	    # Copy keys so exim4 can use them
	    echo "...copying files"
	    sudo cp $SOURCE_DIR/$DOMAIN/fullchain.pem $EXIM_DIR/exim.crt
	    sudo cp $SOURCE_DIR/$DOMAIN/privkey.pem $EXIM_DIR/exim.key
	    
	    # Make sure the exim-user has access
	    echo "...changing ownership"
	    sudo chown root:Debian-exim $EXIM_DIR/{exim.crt,exim.key}
	    
	    ;;
	"imap.rmk2.org")

	    sudo $BIN_DIR/letsencrypt auth --renew-by-default --email $EMAIL -d $DOMAIN -w $SERVER_DIR/eve.rmk2.org/pages
	    
	    ;;
	*)
	    
    esac

    echo "Success!"
   
done

echo "-------------"
echo "Mission accomplished!"
echo
exit 0
