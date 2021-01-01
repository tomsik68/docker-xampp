[![DockerHub:latest](https://github.com/tomsik68/docker-xampp/workflows/Docker%20Image%20CI/badge.svg)](https://hub.docker.com/r/tomsik68/xampp) 
[![Docker Hub](https://img.shields.io/docker/pulls/tomsik68/xampp)](https://hub.docker.com/r/tomsik68/xampp)
[![XAMPP version](https://img.shields.io/badge/XAMPP-8.0.0-1abc9c.svg)](https://www.apachefriends.org/)  [![Gitter](https://badges.gitter.im/docker-xampp/community.svg)](https://gitter.im/docker-xampp/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge) 

```
docker pull tomsik68/xampp:latest
docker run --name myXampp -p 41061:22 -p 41062:80 -d -v ~/my_web_pages:/www tomsik68/xampp
```

This image is intended for PHP+MySQL development. For convenience, it also runs SSH server to connect to. __Both MySQL and phpmyadmin use default XAMPP password__.

## Any questions?

Please read this readme before asking anything.

If you didn't find answer to your question, [create an issue](https://github.com/tomsik68/docker-xampp/issues) or just [ask on Gitter](https://gitter.im/docker-xampp/community). I'll try to help if I can!

## Running the image

This image uses /www directory for your page files, so you need to mount it.

```
docker run --name myXampp -p 41061:22 -p 41062:80 -d -v ~/my_web_pages:/www tomsik68/xampp
```
The command above will expose the SSH server on port 41061 and HTTP server on port 41062.
Feel free to use your own name for the container.

To browse to your web page, visit this URL: [http://localhost:41062/www](http://localhost:41062/www)
And to open up the XAMPP interface: [http://localhost:41062/](http://localhost:41062/)

## Default credentials

service | username | password
------- | -------- | ---------
ssh     | root     | root

## Additional How tos

### ssh connection

default SSH password is 'root'.

```
ssh root@localhost -p 41061
```

### get a shell terminal inside your container

```
docker exec -ti myXampp bash
```

### use binaries provided by XAMPP

Inside docker container:
```
export PATH=/opt/lampp/bin:$PATH
```
You can then use `mysql` and friends installed in `/opt/lampp/bin` in your current bash session. If you want this to persist, you need to add it to your user or system-wide `.bashrc` (inside container).

### Use your own configuration

In your home directory, create a `my_apache_conf` directory in which you place any number of apache configuration directive files. As soon as they end up with the .conf extension, they will be used by the image.

```
docker run --name myXampp -p 41061:22 -p 41062:80 -d -v ~/my_web_pages:/www  -v ~/my_apache_conf:/opt/lampp/apache2/conf.d tomsik68/xampp
```

### Restart the server

Once you have modified configuration for example
```
docker exec myXampp /opt/lampp/lampp restart
```
Please report any issues in issues section on github: https://github.com/tomsik68/docker-xampp/issues where we can track them conveniently. Thanks :)

### phpmyadmin

If you used the `-p41062:80` with `docker run`, just browse to http://localhost:41062/phpmyadmin/ .

## Use a Different XAMPP or PHP Version

Currently, the Docker image is built only for the latest XAMPP version. 
If you need another version, you can easily build a Docker image yourself, here's how:

1. Clone this repo
2. Open `Dockerfile` with your favourite text editor
3. Locate the curl command on line 18: https://github.com/tomsik68/docker-xampp/blob/0d0b77db8965b750197fa2ee27fb1e08aaf6a537/Dockerfile#L18
4. Change the URL to a URL to your desired version. List of versions can be found here: https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/
