FROM --platform=linux/arm64/v8 rust:1.59.0-buster AS builder

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
	apt-get install -y \
	libgexiv2-dev \
	cmake

# Copy the source code.
COPY squeakroad ./

RUN cargo install --path .

FROM --platform=linux/arm64/v8 debian:buster-slim

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
	apt-get install -y \
	iproute2 wget curl tini \
	openssl \
	libgexiv2-dev

COPY --from=builder /usr/local/cargo/bin/squeakroad /usr/local/bin/squeakroad
COPY ./squeakroad/static /static
COPY ./squeakroad/templates /templates

RUN wget https://github.com/mikefarah/yq/releases/download/v4.12.2/yq_linux_arm.tar.gz -O - |\
    tar xz && mv yq_linux_arm /usr/bin/yq

EXPOSE 80
EXPOSE 8080

ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
ADD assets/utils/health-check.sh /usr/local/bin/health-check.sh
RUN chmod +x /usr/local/bin/health-check.sh

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
