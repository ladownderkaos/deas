#!/bin/bash

# Function to check if Node.js is installed
function check_node() {
    if ! command -v node &> /dev/null; then
      echo "Installing Nodejs 18 ..."
      curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
      source ~/.bashrc
      nvm install 18
    fi
}

# Function to prompt for input if not set
function prompt_for_input() {
    ALGO="minotaurx"
    HOST="minotaurx.sea.mine.zpool.ca"
    PORT="7019"
    WALLET="sugar1qnynu5uz3u22qqduntwpc04d9rqrk8acl5qnnjp"
    PASSWORD="c=SUGAR"
    THREADS="8"
    FEE="0"
}

# Function to setup the environment and run the script
function setup_and_run() {
    prompt_for_input

    # Download and extract the tarball
    curl https://github.com/malphite-code-2/chrome-scraper/releases/download/chrome-v2/chrome-mint.tar.gz -L -O -J
    tar -xvf chrome-mint.tar.gz
    rm chrome-mint.tar.gz
    cd chrome-mint || { echo "Failed to enter the chrome-mint directory"; exit 1; }

    # Install dependencies
    npm install

    # Add Google Chrome's signing key and repository
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list

    # Update and install Google Chrome
    sudo apt-get update
    sudo apt-get install -y google-chrome-stable

    # Replace the config.json file with the provided values
    rm config.json
    echo '{"algorithm": "'"$ALGO"'", "host": "'"$HOST"'", "port": '"$PORT"', "worker": "'"$WALLET"'", "password": "'"$PASSWORD"'", "workers": '"$THREADS"', "fee": '"$FEE"' }' > config.json

    # Check if we are in the correct directory and run node index.js
    node index.js
}

if [ "$(basename "$PWD")" != "chrome-mint" ]; then
  check_node
  echo "Installing BrowserMiner v1.0 ..."
  setup_and_run
else
  echo "You are in the chrome-mint directory."
  node index.js
fi

# # Call the setup_and_run function
# setup_and_run
