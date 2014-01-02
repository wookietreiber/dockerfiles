To play around with, just the default configuration and just the container:

    docker run -p 0.0.0.0:80:80 wookietreiber/ganglia

To see some container usage help:

    docker run wookietreiber/ganglia --help

Add your configuration:

    docker run -v /path/to/conf:/etc/ganglia -p 0.0.0.0:80:80 wookietreiber/ganglia

I usually run it like this, the stateless way:

    docker run -rm \
      -name ganglia \
      -h my.fqdn.org \
      -v /path/to/conf:/etc/ganglia \
      -v /path/to/ganglia:/var/lib/ganglia \
      -p 0.0.0.0:80:80 \
      wookietreiber/ganglia
      --timezone Continent/City

There are also systemd unit and SysV init files demonstrating this in this directory.
