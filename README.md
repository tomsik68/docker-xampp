This image is intended for PHP+MySQL development. For convenience, it also runs SSH server to connect to. __Both MySQL and phpmyadmin use default XAMPP password__.


## Running the image:

This image uses /www directory for your page files, so you need to mount it.

```
docker run --name myXampp -p 41061:22 -p 41062:80 -d -v ~/my_web_pages:/www tomsik68/xampp
```
The command above will expose the SSH server on port 41061 and HTTP server on port 41062.    
Feel free to use your own name for the container...

To connect to your web page, visit this URL: [http://localhost:41062/www](http://localhost:41062/www)    
And to open up the XAMPP interface: [http://localhost:41062/](http://localhost:41062/)

## additional How tos

### ssh connection

default SSH password is 'root'.

```
ssh root@localhost -p 41061
```

### Use your own configuration

In your home directory, create a `my_apache_conf` directory in which you place your modified version of `httpd.conf`. Launch the service with

```
docker run --name myXampp -p 41061:22 -p 41062:80 -d -v ~/my_web_pages:/www  -v ~/my_apache_conf:/opt/lamp/apache2/conf tomsik68/xampp
```

### Restart the server

Once you have modified configuration for example
```
docker exec myXampp /opt/lampp/lampp restart
```
Please report any issues in issues section on github: https://github.com/tomsik68/docker-xampp/issues where we can track them conveniently. Thanks :)

