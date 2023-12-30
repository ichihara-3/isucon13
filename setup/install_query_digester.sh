#!/bin/bash
set -e

# pt-query-digest （スローログ解析用ツール）
# 公式: https://docs.percona.com/percona-toolkit/pt-query-digest.html
# 参考記事: https://gihyo.jp/dev/serial/01/mysql-road-construction-news/0009
sudo apt-get update && sudo apt-get install percona-toolkit


# query-digester (pt-query-digestのラップツール)
# https://github.com/kazeburo/query-digester
git clone https://github.com/kazeburo/query-digester.git
cd query-digester
sudo install query-digester /usr/local/bin