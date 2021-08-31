# gslash-server

Server-side stuff for [Geometry Slash](https://github.com/peter0x44/geometryslash.git)

**NOTE**: This project is not complete.

## Setting up

### Prerequisites

* Git (duh)
* Crystal ([see here](https://crystal-lang.org/install/))
* PostgreSQL

### Building

Clone the repository, install the shards and build:

```bash
git clone https://github.com/2secslater/gslash-server.git && cd gslash-server
shards install
crystal build src/gslash.cr --release
```

For cross-compiling, [see here](https://crystal-lang.org/reference/syntax_and_semantics/cross-compilation.html).

### Configuring

#### PostgreSQL

1. Create a user (e.g. `gslash`) with password via standard procedure
1. Create a database (e.g. `gslash`) with the user you created as the owner

#### File

Create the file `/etc/gslash.yml` and open it in a text editor. This is where you'll be setting your PostgreSQL connection details.
Insert the following and replace values where required:

```yaml
db:
  host: localhost
  port: 5432
  user: gslash
  password: yourpassword
  db: gslash
```

## Usage

Simply run the binary wherever you built it.

```bash
./gslash
```

* Currently, the server listens on HTTP port 3000.
* GET request `/top` to receive the top 50 scores in CSV form.
* POST request `/submit` with `username` (string) and `score` (UInt32) in your POST body.

## Contributing

1. Fork it (<https://github.com/2secslater/gslash-server/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
