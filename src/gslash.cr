# gslash-server: Server-side portion for Geometry Slash
# Copyright (C) 2021 Andrew Pirie <twosecslater@snopyta.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

require "db"
require "sqlite3"
require "kemal"
require "csv"

Log.setup_from_env

db = DB.open URI.new("sqlite3", path: "./gslash.db")

# Check if tables exist, and if not, create them
["players", "scores"].each do |table|
  begin
    db.exec "SELECT * FROM #{table} LIMIT 0"
  rescue
    db.exec File.read("schema/#{table}.sql")
    Log.info { "created table #{table}" }
  end
end

before_all do |env|
  env.response.headers["Source"] = "https://github.com/2secslater/gslash-server.git"
end

post "/submit" do |env|
  username = env.params.body["username"].as(String)
  # sqlite doesn't enforce this limit
  if username.size > 16
    env.response.status_code = 400
    next
  end
  score = env.params.body["score"].to_i
  # get uid for username, probably a better way to do this
  begin
    uid = db.query_one("SELECT uid FROM players WHERE uname=(?)", username, as: {Int32})
  rescue
    db.exec "INSERT INTO players VALUES (NULL, ?)", username
  ensure
    uid ||= db.query_one("SELECT uid FROM players WHERE uname=(?)", username, as: {Int32})
  end
  db.exec "INSERT INTO scores VALUES (NULL, ?, ?)", score, uid
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

serve_static false
Kemal.config.powered_by_header = false
Kemal.run
