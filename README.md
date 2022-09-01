[![DockerHub:latest](https://github.com/tomsik68/docker-xampp/workflows/Docker%20Image%20CI/badge.svg)](https://github.com/tomsik68/docker-xampp/actions/workflows/docker-image.yml) 
[![Docker Hub](https://img.shields.io/docker/pulls/tomsik68/xampp)](https://hub.docker.com/r/tomsik68/xampp)
[![XAMPP version](https://img.shields.io/badge/XAMPP-8.1.6-1abc9c.svg)](https://www.apachefriends.org/)  [![Gitter](https://badges.gitter.im/docker-xampp/community.svg)](https://gitter.im/docker-xampp/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge) 

| PHP version | Corresponding tag |
--------------|---------------------
| 8.1.6 | `tomsik68/xampp:8`|
| 7.4.29 | `tomsik68/xampp:7` |
| 5.6.40 | `tomsik68/xampp:5` |

For PHP 8, start your container like this:
```bash
docker run --name myXampp -p 41061:22 -p 41062:80 -d -v ~/my_web_pages:/www tomsik68/xampp:8
```

docker-xampp
===

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

## Additional How-tos

### My app can't function in `/www` folder

No problem, just mount your app in the `/opt/lampp/htdocs` folder, for example:

```
docker run --name myXampp -p 41061:22 -p 41062:80 -d -v ~/my_web_pages:/opt/lampp/htdocs tomsik68/xampp
```

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

In your home directory, create a `my_apache_conf` directory in which you place any number of apache configuration files. As soon as they end with the `.conf` extension, they will be used by xampp. Make sure to use the following flag in your command: `-v ~/my_apache_conf:/opt/lampp/apache2/conf.d`, for example:

```
docker run --name myXampp -p 41061:22 -p 41062:80 -d -v ~/my_web_pages:/www  -v ~/my_apache_conf:/opt/lampp/apache2/conf.d tomsik68/xampp
```

### Restart the server

Once you have modified configuration for example
```
docker exec myXampp /opt/lampp/lampp restart
```

### phpmyadmin

If you used the flag `-p 41062:80` with `docker run`, just browse to http://localhost:41062/phpmyadmin/ .

## Use a Different XAMPP or PHP Version

Currently, the Docker image is built only for PHP 5, 7 and 8.
If you need another version, you can easily build a Docker image yourself, here's how:

1. Clone this repo
2. Find the URL to a URL to your desired version. List of versions can be found here: https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/
3. Build the image using e.g. `docker build --build-arg XAMPP_URL="https://www.apachefriends.org/xampp-files/5.6.40/xampp-linux-x64-5.6.40-1-installer.run?from_af=true" .`
