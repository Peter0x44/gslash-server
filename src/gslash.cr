require "db"
require "pg"
require "kemal"
require "csv"
require "yaml"

config = YAML.parse(File.read("/etc/gslash.yml"))

db = DB.open URI.new("postgres", host: config["db"]["host"].as_s,
  port: config["db"]["port"].as_i,
  user: config["db"]["user"].as_s,
  password: config["db"]["password"].as_s,
  path: config["db"]["db"].as_s)

post "/submit" do |env|
  username = env.params.body["username"].as(String)
  score = env.params.body["score"].to_u32
  env.response.status_code = 200
end

get "/top" do |env|
  env.response.headers["Content-Type"] = "text/csv"
  result = CSV.build do |csv|
    i = 1
    while i <= 50
      csv.row "Test Player #{i}", 4294967295_u32
      i += 1
    end
  end
  result
end

Kemal.config.powered_by_header = false
Kemal.run
