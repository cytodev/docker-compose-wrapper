################################################################################
# ~/.bash_functions                                                            #
################################################################################
function status {
    local pid=${!};

    while kill -0 "${pid}" &> /dev/null; do
        printf "%b\r[      ] %s" "\e[2K" "$1"; sleep 0.125;
        printf "%b\r[%b*     %b] %s" "\e[2K" "\e[0;33m" "\e[m" "$1"; sleep 0.125;
        printf "%b\r[%b*%b*    %b] %s" "\e[2K" "\e[1;33m" "\e[0;33m" "\e[m" "$1"; sleep 0.125;
        printf "%b\r[%b*%b*%b*   %b] %s" "\e[2K" "\e[0;33m" "\e[1;33m" "\e[0;33m" "\e[m" "$1"; sleep 0.125;
        printf "%b\r[ %b*%b*%b*  %b] %s" "\e[2K" "\e[0;33m" "\e[1;33m" "\e[0;33m" "\e[m" "$1"; sleep 0.125;
        printf "%b\r[  %b*%b*%b* %b] %s" "\e[2K" "\e[0;33m" "\e[1;33m" "\e[0;33m" "\e[m" "$1"; sleep 0.125;
        printf "%b\r[   %b*%b*%b*%b] %s" "\e[2K" "\e[0;33m" "\e[1;33m" "\e[0;33m" "\e[m" "$1"; sleep 0.125;
        printf "%b\r[    %b*%b*%b] %s" "\e[2K" "\e[0;33m" "\e[1;33m" "\e[m" "$1"; sleep 0.125;
        printf "%b\r[     %b*%b] %s" "\e[2K" "\e[0;33m" "\e[m" "$1"; sleep 0.125;
        printf "%b\r[      ] %s" "\e[2K" "$1"; sleep 0.125;
        printf "%b\r[     %b*%b] %s" "\e[2K" "\e[0;33m" "\e[m" "$1"; sleep 0.125;
        printf "%b\r[    %b*%b*%b] %s" "\e[2K" "\e[0;33m" "\e[1;33m" "\e[m" "$1"; sleep 0.125;
        printf "%b\r[   %b*%b*%b*%b] %s" "\e[2K" "\e[0;33m" "\e[1;33m" "\e[0;33m" "\e[m" "$1"; sleep 0.125;
        printf "%b\r[  %b*%b*%b* %b] %s" "\e[2K" "\e[0;33m" "\e[1;33m" "\e[0;33m" "\e[m" "$1"; sleep 0.125;
        printf "%b\r[ %b*%b*%b*  %b] %s" "\e[2K" "\e[0;33m" "\e[1;33m" "\e[0;33m" "\e[m" "$1"; sleep 0.125;
        printf "%b\r[%b*%b*%b*   %b] %s" "\e[2K" "\e[0;33m" "\e[1;33m" "\e[0;33m" "\e[m" "$1"; sleep 0.125;
        printf "%b\r[%b*%b*    %b] %s" "\e[2K" "\e[1;33m" "\e[0;33m" "\e[m" "$1"; sleep 0.125;
        printf "%b\r[%b*     %b] %s" "\e[2K" "\e[0;33m" "\e[m" "$1"; sleep 0.125;
    done

    wait ${pid};

    case ${?} in
        -1) printf "%b\r[%bUNKNWN%b] %s\n" "\e[2K" "\e[1;37m" "\e[m" "$1" ;;
        0)  printf "%b\r[%b  OK  %b] %s\n" "\e[2K" "\e[1;32m" "\e[m" "$1" ;;
        *)  printf "%b\r[%bFAILED%b] %s\n" "\e[2K" "\e[1;31m" "\e[m" "$1" ;;
    esac
}

function extract {
    local extractor;

    if [[ -z "$1" ]]; then
        printf "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>\n"

        return 1;
    fi

    if [[ ! -f "$1" ]] ; then
        printf "'%s' - file does not exist\n" "$1"

        return 1;
    fi

    case "$1" in
        *.tar.bz2 | *.tar.gz | *.tar.xz | *.tar | *.tbz2 | *.tgz) extractor=tar        ;;
        *.7z)                                                     extractor=7z         ;;
        *.bz2)                                                    extractor=bunzip2    ;;
        *.exe)                                                    extractor=cabextract ;;
        *.gz)                                                     extractor=gunzip     ;;
        *.lzma)                                                   extractor=unlzma     ;;
        *.rar)                                                    extractor=unrar      ;;
        *.xz)                                                     extractor=unxz       ;;
        *.Z)                                                      extractor=uncompress ;;
        *.zip)                                                    extractor=unzip      ;;
        *.par2)                                                   extractor=par2       ;;
    esac

    if ! which "$extractor" &> /dev/null; then
        printf "missing package '%s'\n" "$extractor";

        return 1;
    fi

    case "$1" in
        *.tar.bz2) tar xvjf "$1"      ;;
        *.tar.gz)  tar xvzf "$1"      ;;
        *.tar.xz)  tar xvJf "$1"      ;;
        *.tar)     tar xvf "$1"       ;;
        *.tbz2)    tar xvjf "$1"      ;;
        *.tgz)     tar xvzf "$1"      ;;
        *.7z)      7z x "$1"          ;;
        *.bz2)     bunzip2 "$1"       ;;
        *.exe)     cabextract "$1"    ;;
        *.gz)      gunzip "$1"        ;;
        *.lzma)    unlzma "$1"        ;;
        *.rar)     unrar x -ad "$1"   ;;
        *.xz)      unxz "$1"          ;;
        *.Z)       uncompress "$1"    ;;
        *.zip)     unzip "$1"         ;;
        *.par2)    par2 r "$1" "$1.*" ;;
        *)
            printf "extract: '%s' - unknown archive method\n" "$1";

            return 1;
    esac

    return ${?};
}

function icanhaz {
    case "${1}" in
        "ip")         curl icanhazip.com         ;;
        "ptr")        curl icanhazptr.com        ;;
        "trace")      curl icanhaztrace.com      ;;
        "traceroute") curl icanhaztraceroute.com ;;
        "epoch")      curl icanhazepoch.com      ;;
        "proxy")      curl icanhazproxy.com      ;;
        *)
            printf "icanhaz '%s' - unknown thing\n" "$1";

            return 1;
    esac
}
