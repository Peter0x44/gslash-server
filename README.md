# gslash-server

Server-side code for [Geometry Slash](https://github.com/peter0x44/geometryslash.git)

**NOTE**: This project is not complete.

## Setting up using Docker (recommended for production servers)

You can either pull the image from the container registry (coming soon), or build the image yourself as follows:

### Prerequisites
* Docker (well, obviously)
* Git (only when building yourself) 

### Building with Docker on your own

Clone the repository and build the Docker image:
```bash
git clone https://github.com/2secslater/gslash-server.git && cd gslash-server
docker build -t gslashserver:latest .
```
### Usage
Once you have pulled the image from the registry or built it yourself you can run it as such:
```bash
docker run -d -p YOUR_PORT:3000 gslashserver:latest
```
Where `YOUR_PORT` is the port that you will be able to access your server from, make sure to forward it if you want public access.

## Setting up on your system (recommended for development or LAN hosting)

### Prerequisites

* Git (duh)
* Crystal ([see here](https://crystal-lang.org/install/))
* SQLite3

### Building

Clone the repository, install the shards and build:

```bash
git clone https://github.com/2secslater/gslash-server.git && cd gslash-server
shards build --production
```

* Optionally, you can append `--release` to the `shards build` command for optimised binaries at the expense of build time.
* For cross-compiling, [see here](https://crystal-lang.org/reference/syntax_and_semantics/cross-compilation.html).

## Usage

Simply run the binary wherever you built it.

```bash
./bin/gslash
```

Run `./bin/gslash --help` for configuring the interface, port and SSL/TLS key/cert if needed.

* GET request `/top` to receive the top 50 scores in CSV form.
* POST request `/submit` with `username` (string) and `score` (UInt32) in your POST body.

## Contributing

1. Fork it (<https://github.com/2secslater/gslash-server/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
