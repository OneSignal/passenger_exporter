# passenger_exporter_nginx

[![CircleCI](https://circleci.com/gh/OneSignal/passenger_exporter/tree/master.svg?style=svg)](https://circleci.com/gh/OneSignal/passenger_exporter/tree/master)

This is a Prometheus exporter for passenger with nginx integration.

https://www.phusionpassenger.com/

CI build added by @OneSignal.  Local build steps are copied below for posterity.

## Running the Exporter

Usage of passenger_exporter_nginx:
```
  -log.format value
      If set use a syslog logger or JSON logging.
      Example: logger:syslog?appname=bob&local=7 or logger:stdout?json=true.
      Defaults to stderr.
  -log.level value
      Only log messages with the given severity or above.
      Valid levels: [debug, info, warn, error, fatal]. (default info)
  -passenger.command string
      Passenger command for querying passenger status.
      (default "passenger-status --show=xml")
  -passenger.pid-file string
    	Optional path to a file containing the passenger/nginx PID for additional metrics.
  -passenger.command.timeout duration
      Timeout for passenger.command. (default 500ms)
  -web.listen-address string
      Address to listen on for web interface and telemetry. (default ":9149")
  -web.telemetry-path string
      Path under which to expose metrics. (default "/metrics")
```

## (locally) Building the Exporter

The default Makefile target creates a statically linked binary for Linux.

A Dockerfile and Makefile target are also supplied:

```bash
make build-docker
```

To run the Docker image:

```bash
docker run -p 9106:9106 -v $PATH_TO_PASSENGER_STATUS:/bin \
        osig/passenger-exporter:latest
```

Notes for running the Docker container:

- You must expose the -web.listen-address port on the container to be scraped.

## Collectors

An example of the metrics exported can be seen in testdata/scrape_output.txt

## Running Tests

Tests can be run with:

```bash
go test .
```

These are run automatically by the CI process on push.

Additionally, the testdata/scrape_output.txt can be regenerated by passing the
--golden flag:

```bash
go test -v . --golden
```
