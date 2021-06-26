.PHONY: gogo all app bench slow-log kataribe
all: app

app: *.go go.mod go.sum
	go build -o app

gogo:
	sudo systemctl stop nginx.service
	sudo systemctl stop isu-go.service
	sudo truncate --size 0 /var/log/nginx/access.log
	sudo truncate --size 0 /var/log/mysql/mysql-slow.sql
	$(MAKE) all
	sudo systemctl start isu-go.service
	sudo systemctl start nginx.service
	sleep 2
	make bench

bench:
	ssh -i ~/.ssh/id_rsa ubuntu@3.115.116.51 /home/isucon/private_isu.git/benchmarker/bin/benchmarker -u /home/isucon/private_isu.git/benchmarker/userdata -t http://35.75.16.62

slow-log:
	sudo truncate --size 0 /home/mysql-slow.sql
	sudo cp mysql/mysql-slow.sql /home/mysql-slow.sql
	chown ubuntu /home/mysql-slow.sql

kataribe:
	sudo cp /var/log/nginx/access.log /tmp/last-access.log && sudo chmod 666 /tmp/last-access.log
	cat /tmp/last-access.log | ./kataribe -conf kataribe.toml > /tmp/kataribe.log
	cat /tmp/kataribe.log
