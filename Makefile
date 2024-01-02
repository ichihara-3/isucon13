# ===============
# isucon用Makefile
# ================


SHELL := /bin/bash
NOW = $(shell date +'%Y%m%d.%H%M%S')


# コマンドリスト
.PHONY: list
list:
	@echo ==== コマンド一覧 ====
	@echo "restart" - restart
	@echo "nginx-restart - nginxの再起動"
	@echo "nginx-rotate - nginxのログ入換+再起動"
	@echo "alp - alp (Access Log Profiler) を実行する"
	@echo "mysql - MySQLに接続"
	@echo "mysql-restart - MySQLサーバ再起動"
	@echo "slowlog - MySQL slowlog取得(実行後30秒間の間のログを解析する）"
	@echo "setup - 初期設定"


# 再起動
NGINX_RESTART = sudo systemctl restart nginx.service
APP_RESTART = sudo systemctl restart isupipe-go.service
GO_BUILD = cd "$(PWD)/go/" && make build 
SQL_RUN = $(MYSQL) isupipe < "$(PWD)/sql/initdb.d/10_schema.sql"
MYSQL_INIT = bash /home/isucon/webapp/sql/init.sh
MYSQL_ROTATE = $(SSH_MYSQL_HOST) 'sudo test -f /var/log/mysql/mysql-slow.log && sudo mv /var/log/mysql/mysql-slow.log /var/log/mysql/mysql-slow.log.$(NOW) || echo "no slowlog"'

.PHONY: build
build:
	$(GO_BUILD)
	$(APP_RESTART)
	$(SQL_RUN)
	$(MYSQL_ROTATE)
	$(MYSQL_RESTART)
	$(MYSQL_INIT)
	sudo mv $(NGINX_LOG_PATH) $(NGINX_LOG_PATH).$(NOW)
	$(NGINX_RESTART)

.PHONY: restart
restart:
	$(APP_RESTART)
	$(NGINX_RESTART)

.PHONY: nginx-restart
nginx-restart:
	$(NGINX_RESTART)


NGINX_LOG_PATH=/var/log/nginx/access.log
.PHONY: nginx-rotate
nginx-rotate:
	sudo mv $(NGINX_LOG_PATH) $(NGINX_LOG_PATH).$(NOW)
	$(NGINX_RESTART)



# access log profiler
# 一番新しいログのアクセスログを見る
# ログローテートする仕組み入れないとうまくいかないよ
# ログはJSON形式想定、違ったら変えて
# https://github.com/tkuchiki/alp/blob/main/docs/usage_samples.ja.md ここ参考のこと
LOGFILE=$(shell ls -1t /var/log/nginx/*.log* |head -n 1)
ALP=sudo cat $(LOGFILE) | alp json --sort sum --reverse -m "/api/livestream/\d+/statistics,/api/livestream/\d+/livecomment,/api/livestream/\d+/moderate,/api/livestream/\d+/enter,/api/livestream/\d+/exit,/api/livestream/\d+/reaction,/api/livestream/\d+$$,/api/livestream/\d+/report,/api/livestream/\d+/ngwords,/api/user/[0-9a-zA-Z]+$$,/api/user/[0-9a-zA-Z]+/statistics,/api/user/[0-9a-zA-Z]+/icon,/api/user/[0-9a-zA-Z]+/livestream,/api/user/[0-9a-zA-Z]+/theme,/watch/\d+$$"
.PHONY: alp
alp:
	echo $(LOGFILE)
	$(ALP)

# MySQL
MYSQL_HOST=192.168.0.12
MYSQL_USER=isucon
MYSQL_PASSWORD=isucon
MYSQL_DATABESE=DATABASE

SSH_MYSQL_HOST=ssh $(USER)@$(MYSQL_HOST)
MYSQL=mysql -h$(MYSQL_HOST) -u$(USER) -p$(MYSQL_PASSWORD)
MYSQL_RESTART=$(SSH_MYSQL_HOST) sudo systemctl restart mysql.service

# mysqlに接続する
.PHONY: mysql
mysql:
	$(MYSQL)

.PHONY: mysql-restart
mysql-restart:
	$(MYSQL_RESTART)

.PHONY: slowlog
slowlog:
	$(SSH_MYSQL_HOST) sudo pt-query-digest /var/log/mysql/mysql-slow.log

.PHONY: setup
setup:
	bash setup/install_alp.sh
	bash setup/install_query_digester.sh

