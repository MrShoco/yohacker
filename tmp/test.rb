require './lib/connection'

require './models/user'

Connection.connect_db("development")

p User.all

