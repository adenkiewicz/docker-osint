export PS1="\u:\w> "
export PATH="$PATH:/opt"

alias subfinder="/opt/subfinder -pc /private/subfinder/config.yaml"

function subfinder_show_alive() {
    subfinder $* | /opt/httprobe
}

# setup wraith config
WRAITH_CONFIG="/root/.wraith/config.yml"
if [[ ! -f $WRAITH_CONFIG ]]
then
    ln -s /private/wraith/config.yml $WRAITH_CONFIG
fi

alias github_scan_users="/opt/wraith scanGithub --github-users"
alias github_scan_repos="/opt/wraith scanGithub --github-repos"
alias github_scan_orgs="/opt/wraith scanGithub --github-orgs"

function dns_discover_names() {
    dnsgen <(echo $*) | /opt/massdns -r /opt/massdns-lists/resolvers.txt -o S -w >(cat)
}