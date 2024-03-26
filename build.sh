#!/bin/bash

docker build -t dobl1/go-bench-suite:latest --no-cache --build-arg VERSION=master .
docker push dobl1/go-bench-suite:latest
