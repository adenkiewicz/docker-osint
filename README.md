# OSINT docker image

## Tools

### Wraith

Github recon tool.

Put your github token (and other secrets into `private/wraith/config.yml`) - use project sample config, then modify

#### Friendy aliases

* `github_scan_users`: lookup secrets based on users
* `github_scan_orgs`: based on orgs
* `github_scan_repos`: based on repo name

### Subfinder

Subdomain finder that uses bunch of useful sources. To enable them put tokens into `private/subfinder/config.yaml`.

#### Friendy aliases

* `subfinder_show_alive`: call `subfinder` as you wish, then verify with `httprobe` if host is alive (assuming `http/https` service)

### Anew

### HTTProbe

### DNSGen

## Tested, but removed

### Subjack

Subdomain Takeover tool written in Go, didn't work due to https://github.com/haccer/subjack/issues/89

