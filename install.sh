#!/usr/bin/env bash


check_if_running_as_root() {
  # If you want to run as another user, please modify $UID to be owned by this user
  if [[ "$UID" -ne '0' ]]; then
    echo "WARNING: The user currently executing this script is not root. You may encounter the insufficient privilege error."
    read -r -p "Are you sure you want to continue? [y/n] " cont_without_been_root
    if [[ x"${cont_without_been_root:0:1}" = x'y' ]]; then
      echo "Continuing the installation with current user..."
    else
      echo "Not running with root, exiting..."
      exit 1
    fi
  fi
}
download_files() {
    git clone https://github.com/0x187/v2ray_tools.git /root/v2ray/
}



main() {
  check_if_running_as_root
  apt update
  apt install git
  mkdir -p /root/v2ray/install
  download_files
  bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
  "$@"
}

main "$@"
