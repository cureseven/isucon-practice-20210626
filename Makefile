.PHONY: gogo
all: app

app: *.go go.mod go.sum
	go build -o app

gogo: 
	sudo systemctl stop nginx.service
	sudo systemctl stop isu-go.service
	sudo systemctl stop mysql.service
	sudo truncate --size 0 /var/log/nginx/access.log
    -sudo truncate --size 0 /var/log/mysql/mysql-slow.sql
	$(MAKE) all
	sudo systemctl start mysql.service
	sleep 2
	sudo systemctl start isu-go.service
	sudo systemctl start nginx.service
	sleep 2
	ssh ubuntu@3.115.116.51 "make bench"