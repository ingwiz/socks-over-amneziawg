#!/bin/sh

set -ue

CONF=/etc/awg.conf
WG_CONF=/etc/_wg.conf
WG_IF=wg0

die() {
    echo Error: $@ >&2
    exit 1
}

[ ! -f $CONF ] && die Absent $CONF config file

sed '/^Address =/d; /^DNS =/d' $CONF > $WG_CONF

ENDPOINT=$(sed -E -n '/^Endpoint = / s/.* ([0-9.]+):.*/\1/p' $CONF)
CIDR=$(sed -E -n '\|^Address =| s|.* ([0-9./]+)$|\1|p' $CONF)

set -x

DEFAULT_VIA=$(ip route | sed -n '/^default/ s/default//p')

/usr/local/sbin/amneziawg-go $WG_IF
sleep 1

/usr/local/sbin/awg setconf $WG_IF $WG_CONF
ip addr add $CIDR dev $WG_IF
ip link set $WG_IF up

ip route add $ENDPOINT $DEFAULT_VIA
ip route replace default dev $WG_IF

while : ;
    echo  [$(date)] : $(curl --max-time 5 http://ifconfig.me)
    sleep 15
done