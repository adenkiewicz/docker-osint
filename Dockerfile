# build tools in temp container
FROM golang:1.19-alpine AS build-env
RUN apk -U upgrade --no-cache \
    && apk add --no-cache bash make git build-base
RUN go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
RUN go install github.com/tomnomnom/anew@latest
RUN go install github.com/tomnomnom/httprobe@latest
RUN go install -v github.com/OWASP/Amass/v3/...@master

# build wraith (https://github.com/N0MoreSecr3ts/wraith)
RUN cd /tmp/ \
    && git clone https://github.com/N0MoreSecr3ts/wraith.git \
    && cd wraith \
    && make build \
    && git clone https://github.com/N0MoreSecr3ts/wraith-signatures.git \
    && mv ./bin/wraith-linux /opt/wraith

# build massdns
RUN cd /tmp \
    && git clone https://github.com/blechschmidt/massdns.git \
    && cd massdns \
    && make \
    && mv ./bin/massdns /opt \
    && mv lists /opt/massdns-lists \
    && mv scripts /opt/massdns-scripts

# copy everything to /opt
RUN cp -R /go/bin/* /opt

# Create OSINT container
FROM alpine:3.15.0
RUN apk -U upgrade --no-cache \
    && apk add --no-cache bind-tools ca-certificates bash python3 py3-pip \
    && rm -rf /var/lib/apt/lists/
COPY --from=build-env /opt /opt

# add wraith signatures
RUN mkdir -p /root/.wraith/signatures
COPY --from=build-env /tmp/wraith/wraith-signatures/signatures /root/.wraith/signatures

# add dnsgen
RUN pip3 install dnsgen

# save and autoload aliases
COPY profile /root/.bashrc

WORKDIR /shared
ENTRYPOINT ["/bin/bash"]
