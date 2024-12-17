#!/bin/bash

# Define colors
RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"
PURPLE="\033[1;35m"

# Define usage information
usage() {
  echo -e "${YELLOW}Usage:${RESET} $0 ${GREEN}[-u]${RESET} ${BLUE}[-s <Search Term>]${RESET} ${YELLOW}[-h]${RESET} ${PURPLE}[-q]${RESET}" >&2
  echo -e "${YELLOW}Options:${RESET}" >&2
  echo -e "-u                 Update clouds data" >&2
  echo -e "-s <Search Term>   Search for a domain or subdomain containing your search term in clouds data" >&2
  echo -e "-h                 Display this help message" >&2
  echo -e "-q                 Silent mode, suppress all output" >&2
  exit 1
}

# Initialize variables
DOMAIN=""
UPDATE=0
SILENT=0

# Logger function
log() {
  local level=$1
  local message=$2
  if [ $SILENT -eq 0 ]; then
    case $level in
      INFO)
        echo -e "[${YELLOW}INF${RESET}] $message${RESET}" >&2
        ;;
      OK)
        echo -e "[${GREEN}OK${RESET}] $message${RESET}" >&2
        ;;
      ERROR)
        echo -e "[${RED}ERR${RESET}] $message${RESET}" >&2
        ;;
      *)
        echo "Invalid log level" >&2
        ;;
    esac
  fi
}

# Parse command line arguments
while getopts "uhs:q" opt; do
  case $opt in
    u)
      UPDATE=1
      ;;
    s)
      DOMAIN="$OPTARG"
      ;;
    h)
      usage
      ;;
    q)
      SILENT=1
      ;;
    \?)
      log ERROR "Invalid option: -$OPTARG" >&2
      usage
      ;;
  esac
done

# Function to update cloud data
update() {
  if [ $SILENT -eq 0 ]; then
    log INFO "Updating cloud"
  fi
  mkdir -p "$HOME/.cloudscrt/"
  rm -rf "$HOME/.cloudscrt/"*
  wget http://kaeferjaeger.gay/sni-ip-ranges/amazon/ipv4_merged_sni.txt -O "$HOME/.cloudscrt/amazon.txt" --quiet && log OK "Amazon done" || log ERROR "Failed to update Amazon"
  wget http://kaeferjaeger.gay/sni-ip-ranges/digitalocean/ipv4_merged_sni.txt -O "$HOME/.cloudscrt/digitalocean.txt" --quiet && log OK "DigitalOcean done" || log ERROR "Failed to update DigitalOcean"
  wget http://kaeferjaeger.gay/sni-ip-ranges/microsoft/ipv4_merged_sni.txt -O "$HOME/.cloudscrt/microsoft.txt" --quiet && log OK "Microsoft done" || log ERROR "Failed to update Microsoft"
  wget http://kaeferjaeger.gay/sni-ip-ranges/google/ipv4_merged_sni.txt -O "$HOME/.cloudscrt/google.txt" --quiet && log OK "Google done" || log ERROR "Failed to update Google"
  wget http://kaeferjaeger.gay/sni-ip-ranges/oracle/ipv4_merged_sni.txt -O "$HOME/.cloudscrt/oracle.txt" --quiet && log OK "Oracle done" || log ERROR "Failed to update Oracle"
}

# Function to search for a domain in cloud data
search() {
  query="$1"
  if [ -z "$query" ]; then
    log ERROR "No query specified"
    exit 1
  fi

  if [ -d "$HOME/.cloudscrt" ]; then
    cat "$HOME/.cloudscrt/"*".txt" | grep -F ".$query" | awk -F'-- ' '{print $2}'| tr ' ' '\n' | tr '[' ' '| sed 's/ //'| sed 's/\]//'| grep -F ".$query" | sort -u
  else
    log ERROR "~/.cloudscrt not found"
    exit 1
  fi
}

# Main function
main() {
  if [ $UPDATE -eq 1 ]; then
    update
  fi
  if [ -n "$DOMAIN" ]; then
    search "$DOMAIN"
  fi
  if [[ "$UPDATE" -eq 0 && "$DOMAIN" == "" ]]; then
    if [ $SILENT -eq 0 ]; then
      echo "" >&2
      usage
    fi
  fi
}

# Display banner
displayBanner(){
    if [ $SILENT -eq 0 ]; then
    echo -e "${PURPLE}   _______             __  ___                  " >&2
    echo -e "${PURPLE}  / ___/ /__  __ _____/ / / _ \___ _______  ___ " >&2
    echo -e "${PURPLE} / /__/ / _ \/ // / _  / / , _/ -_) __/ _ \/ _ \\" >&2
    echo -e "${PURPLE} \___/_/\___/\_,_/\_,_/ /_/|_|\__/\__/\___/_//_/" >&2
    echo -e "                            ${GREEN}github.com/Spix0r${RESET}" >&2
    fi
}

# Run the main function
displayBanner
main
