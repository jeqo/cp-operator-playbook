CP_VERSION := 5.5.0

.PHONY: all
all:

.PHONY: download
download:
	wget -O confluent-operator-${CP_VERSION}.tar.gz https://platform-ops-bin.s3-us-west-1.amazonaws.com/operator/confluent-operator-${CP_VERSION}.tar.gz
	mkdir -p cp-operator/
	tar -xf confluent-operator-${CP_VERSION}.tar.gz -C cp-operator/