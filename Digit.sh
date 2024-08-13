#!/bin/bash

show_help() {
    echo "Usage: $0 [-d domain] [-L domain_list] [-h]"
    echo ""
    echo "Options:"
    echo "  -d    Specify a single domain to process."
    echo "  -L    Provide a file containing a list of domains to process."
    echo "  -h    Show this help manual."
}

function ver_idf() {
    local_version=v0.0.1

    latest_version=$(curl -s https://github.com/Byte-BloggerBase/DigIT/releases/latest | grep '"tag_name":' | cut -d '"' -f 4)

    if [ "$local_version" != "$latest_version" ]; then
        echo "Your version ($local_version) is outdated. The latest version is $latest_version."
        read -p "Do you want to update to the latest version? (y/n): " choice
        if [ "$choice" == "y" ]; then
            echo "Updating to version $latest_version..."
            wget -O "$0" https://raw.githubusercontent.com/Byte-BloggerBase/DigIT/main/Digit.sh
            echo "Update completed || Current Version ($latest_version)."
            echo "Run the tool again...."
            local_version=$latest_version
            exit 0
        else
            echo "Update canceled."
        fi
    else
        echo "You are using the latest version ($local_version)."
        local_version=$latest_version
    fi
}

function banner() {
printf "  ____  _       ___ _____  \n"
printf " |  _ \(_) ____|_ _|_   _| \n"
printf " | | | | |/ _  || |  | |    \n"
printf " | |_| | | (_| || |  | |    \n"
printf " |____/|_|\__, |___| |_|    \n"
printf "          |___/ Developed by:harshj054 \n"
}
banner


ver_idf
crt_search() {
    local domain=$1
    mkdir -p "ext" "$domain-output" "$domain-output/wayback_data" 
    
    
    subfinder -d "$domain" -o "ext/subfinder.txt"  > /dev/null 2>&1
    # assetfinder -subs-only "$domain" | tee  "ext/assetfinder.txt"
    amass enum -passive -norecursive -noalts -d "$domain" -o "ext/amass-enum.txt" > /dev/null 2>&1
    
    cat "ext/subfinder.txt" \
        "ext/amass-enum.txt" \
        | sort | uniq > "ext/combined_subdomains.txt"

    
    curl -s "https://crt.sh/?q=%.$domain&output=json" | jq -r '.[] | .name_value | split("\n")[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort | uniq >> "ext/combined_subdomains.txt"
    
    sort -u "ext/combined_subdomains.txt" > "$domain-output/sorted_all_$domain-subs.txt"
}

wayback_machine() {
    local domain=$1
    while read -r subdomain; do
        response=$(curl -s "https://web.archive.org/cdx/search/cdx?url=*.$subdomain/*&output=text&fl=original&collapse=urlkey")
        
        if [ ! -z "$response" ] && \
           [ "$subdomain" != "crt.sh" ] && [ "$subdomain" != "$domain" ] && \
           [ "$subdomain" != "fonts.googleapis.com" ] && [ "$subdomain" != "span.heading" ] && \
           [ "$subdomain" != "span.title" ] && [ "$subdomain" != "span.text" ] && \
           [ "$subdomain" != "span.whiteongrey" ] && [ "$subdomain" != "table.options" ] && \
           [ "$subdomain" != "td.outer" ]; then
            echo "$response" >> "$domain-output/wayback_data/$subdomain-wayback_data.txt"
            echo "$subdomain" >> "$domain-output/on_wayback-subs.txt"
        fi
    done < "$domain-output/sorted_all_$domain-subs.txt"
}

process_domain() {
    local domain=$1
    crt_search "$domain"
    wayback_machine "$domain"
    rm -r ext
}

process_domain_list() {
    local domain_list=$1
    while IFS= read -r domain || [ -n "$domain" ]; do
        process_domain "$domain"
    done < "$domain_list"
}


show_help_and_exit() {
    show_help
    exit 1
}

if [ $# -eq 0 ]; then
    show_help_and_exit
fi


while getopts "d:L:h" opt; do
    case ${opt} in
        d)
            domain=${OPTARG}
            process_domain "$domain"
            ;;
        L)
            domain_list=${OPTARG}
            process_domain_list "$domain_list"
            ;;
        h)
            show_help
            exit 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            show_help_and_exit
            ;;
    esac
done

if [ $OPTIND -eq 1 ]; then
    show_help_and_exit
fi

exit 0

