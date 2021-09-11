# gslash-server

Server-side code for [Geometry Slash](https://github.com/peter0x44/geometryslash.git)

**NOTE**: This project is not complete.

## Setting up using Docker (recommended for production servers)

### Prerequisites
* Docker (well, obviously)
* Git (only when building yourself) 

You can either pull the image from the container registry using `docker pull ghcr.io/2secslater/gslash-server:latest`, or build the image yourself as follows:

### Building with Docker on your own

Clone the repository and build the Docker image:
```bash
git clone https://github.com/2secslater/gslash-server.git && cd gslash-server
docker build -t gslashserver:latest .
```
### Usage
Once you have pulled the image from the registry or built it yourself you can run it as such:
```bash
docker run -d -p YOUR_PORT:3000 gslash-server:latest
```
Where `YOUR_PORT` is the port that you will be able to access your server from, make sure to forward it if you want public access.

## Setting up on your system (recommended for development or LAN hosting)

### Prerequisites

* Git (duh)
* Crystal ([see here](https://crystal-lang.org/install/))
* SQLite3
* Reverse proxy (such as h2o or nginx) if you wish to have ratelimiting

### Building

Clone the repository, install the shards and build:

```bash
git clone https://github.com/2secslater/gslash-server.git && cd gslash-server
shards build --production
```

* Optionally, you can append `--release` to the `shards build` command for optimised binaries at the expense of build time.
* For cross-compiling, [see here](https://crystal-lang.org/reference/syntax_and_semantics/cross-compilation.html).

### Usage

Simply run the binary wherever you built it.

```bash
./bin/gslash
```

Run `./bin/gslash --help` for configuring the interface, port and SSL/TLS key/cert if needed.

* GET request `/top` to receive the top 50 scores in CSV form.
  * First row indicates the count of scores being stored in the database. Used for paging on the client.
  * Using with parameter `player` with value (String) will return single top score for the player specified.
  * Using with parameter `from` with value (Int32) will return top 50 scores with the value being the offset. Used for paging on the client.
* POST request `/submit` with `username` (string) and `score` (UInt32) in your POST body.

### Setting up service

#### OpenRC

See the `services/openrc` directory and install the files onto your server. Change the variables where necessary and make sure `/etc/init.d/gslash` is executable.

* By default, it expects that you have a user named `gslash` with its own group and home directory located at `/var/lib/gslash`.
* It also expects the server repository to be located at `/var/lib/gslash/gslash-server`.
* The above can all be changed in `/etc/init.d/gslash`.
* Other configuration variables can be found in `/etc/conf.d/gslash`.

#### systemd

TODO

## Setting up using Docker

Setting up with Docker may be quicker and easier compared to the traditional method.

### Prerequisites

* Docker (well, obviously)
* Git (only when building yourself) 

You can either pull the image from the container registry using `docker pull ghcr.io/2secslater/gslash-server:latest`, or build the image yourself as follows:

### Building with Docker on your own

Clone the repository and build the Docker image:
```bash
git clone https://github.com/2secslater/gslash-server.git && cd gslash-server
docker build -t gslashserver:latest .
```
### Usage
Once you have pulled the image from the registry or built it yourself you can run it as such:
```bash
docker run -d -p YOUR_PORT:3000 gslash-server:latest
```
Where `YOUR_PORT` is the port that you will be able to access your server from, make sure to forward it if you want public access.

## Setting up reverse proxy (optional)

This step is entirely optional, and is recommended if you wish to implement ratelimiting.

**NOTE**: In development, the game may last 15 seconds long. Otherwise, it may be longer. In any case, ensure that the ratelimit does not exceed the game's time.

#### h2o

**NOTE**: For ratelimiting to work, your h2o install must have mruby support

```yaml
hosts:
  gslash.example.tld:
    listen:
      port: 443
      ssl:
        certificate-file: /etc/ssl/gslash.example.tld.cert
        key-file: /etc/ssl/gslash.example.tld.key
    paths:
      /:
        proxy.reverse.url: http://127.0.0.1:3000
      /submit:
        mruby.handler: |
          require "dos_detector.rb"
          DoSDetector.new({
            :strategy => DoSDetector::CountingStrategy.new({
              :period => 15,
              :threshold => 1,
              :ban_period => 15
            })
          })
        proxy.reverse.url: http://127.0.0.1:3000/submit
```

#### nginx

```nginx
#limit_req_zone $binary_remote_addr zone=scoreSubmit:10m rate=1r/m; # one request per minute
limit_req_zone $binary_remote_addr zone=scoreSubmit:10m rate=4r/m; # one request per 15 seconds

server {
  server_name gslash.example.tld;
  listen 443 ssl http2;
  listen [::]:443 ssl http2;
  
  ssl_certificate /etc/ssl/gslash.example.tld.cert;
  ssl_certificate_key /etc/ssl/gslash.example.tld.key;

  location / {
    proxy_pass http://127.0.0.1:3000;
  }

  location /submit {
    limit_req zone=scoreSubmit;
    proxy_pass http://127.0.0.1:3000/submit;
  }
}
```

## Contributing

1. Fork it (<https://github.com/2secslater/gslash-server/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
