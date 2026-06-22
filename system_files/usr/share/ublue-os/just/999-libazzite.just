# vim: set ft=make :

# Enbale development mode.
[group('System')]
devmode:
    #!/usr/bin/env bash
    set -e
    if [[ "$(jq '."os-category"' /usr/share/ublue-os/image-info.json)" == "workspace" ]] ; then
        echo "Already in devmode."
        exit 0
    else
        gum confirm "Would you like to disable development mode?" || exit 0
    fi
    proxy_args=()
    proxy_http="${HTTP_PROXY:-${http_proxy:-}}"
    [[ -n "$proxy_http" ]] && proxy_args+=("HTTP_PROXY=$proxy_http" "http_proxy=$proxy_http")
    proxy_https="${HTTPS_PROXY:-${https_proxy:-}}"
    [[ -n "$proxy_https" ]] && proxy_args+=("HTTPS_PROXY=$proxy_https" "https_proxy=$proxy_https")
    proxy_no="${NO_PROXY:-${no_proxy:-}}"
    [[ -n "$proxy_no" ]] && proxy_args+=("NO_PROXY=$proxy_no" "no_proxy=$proxy_no")
    set +e
    if [[ ${#proxy_args[@]} -eq 0 ]]; then
        pkexec bootc switch ghcr.io/atom-l/libluefin:latest --apply
    else
        pkexec env "${proxy_args[@]}" bootc switch ghcr.io/atom-l/libluefin:latest --apply
    fi
