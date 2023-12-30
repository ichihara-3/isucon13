#!/bin/bash
set -e
curl -LO 'https://github.com/tkuchiki/alp/releases/download/v1.0.21/alp_linux_amd64.tar.gz'
tar xzf alp_linux_amd64.tar.gz
sudo install alp /usr/local/bin/alp
rm -f alp alp_linux_amd64.tar.gz