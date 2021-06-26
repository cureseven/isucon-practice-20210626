.PHONY: gogo all app
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
