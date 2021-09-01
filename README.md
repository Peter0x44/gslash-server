# gslash-server

Server-side stuff for [Geometry Slash](https://github.com/peter0x44/geometryslash.git)

**NOTE**: This project is not complete.

## Setting up

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
./gslash
```

Run `./gslash --help` for configuring the interface, port and SSL/TLS key/cert if needed.

* GET request `/top` to receive the top 50 scores in CSV form.
* POST request `/submit` with `username` (string) and `score` (UInt32) in your POST body.

## Contributing

1. Fork it (<https://github.com/2secslater/gslash-server/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
