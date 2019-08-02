require_relative '../config/environment'
require_relative "../lib/interface"
require_relative "../lib/user"

cli = Interface.new
user_object = nil
while !user_object
  user_object = cli.welcome
end

cli.user = user_object
user_object.interface = cli

binding.pry
puts "hello world"
