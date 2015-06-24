#!/bin/bash

usage() { cat << EOF
Usage: docker run wookietreiber/ganglia [opts]

Run a ganglia-web container.

    -? | -h | -help | --help            print this help
    --with-gmond                        also run gmond inside the container
    --without-gmond                     do not run gmond inside the container
    --timezone arg                      set timezone within the container,
                                        must be path below /usr/share/zoneinfo,
                                        e.g. Europe/Berlin

EOF
}

while true ; do
  case "$1" in
    -?|-h|-help|--help)
      usage
      exit 0
      ;;

    --with-gmond)
      WITH_GMOND=y
      shift
      ;;

    --without-gmond)
      unset WITH_GMOND
      shift
      ;;

    --timezone)
      shift
      TIMEZONE=$1
      shift
      ;;

    "")
      break
      ;;

    *)
      usage > /dev/stderr
      exit 1
      ;;
  esac
done

set -x

# --------------------------------------------------------------------------------------------------
# preparation
# --------------------------------------------------------------------------------------------------

# just to be on the safe side
mkdir -p /var/lib/ganglia/rrds

# make sure 'nobody' owns the rrds or else gmetad will complain (this is needed explicitly here, in
# case a bind mount from the host is used, i.e. docker run -v /path/to:/var/lib/ganglia ...)
chown -R nobody:nobody /var/lib/ganglia/rrds

# apply timezone if set
[[ -n $TIMEZONE ]] && ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime

# --------------------------------------------------------------------------------------------------
# services
# --------------------------------------------------------------------------------------------------

service httpd start

[[ -n $WITH_GMOND ]] && gmond

# last command must stay in foreground, this is the main reason for -d 1
gmetad -d 1
