require_relative '../config/environment'
  #t.string :name
#   t.integer :age
#   t.string :relationship_status
#   t.date :birthday
# user1 = User.create(     
#     :name => "alessandra vertrees",
#     :age => 23,
#     :relationship_status => "in a relationship",
#     :birthday => 06/07/1996 #needs work
#     )

# user2 = User.create(     
#     :name => "gulnoza",
#     :age => 31,
#     :relationship_status => "married",
#     :birthday => 06/07/1996 #needs work
#     )


# HandCard.create(
#     :user_id => user1.id,
#     :card_id => rand(5)
# )

# HandCard.create(
#     :user_id => user1.id,
#     :card_id => rand(5..10)
# )    
# HandCard.create(
#     :user_id => user1.id,
#     :card_id => rand(10...20)
# )
# HandCard.create(
#     :user_id => user1.id,
#     :card_id => rand(20...79)
# )


# HandCard.create(
#     :user_id => user2.id,
#     :card_id => rand(5)
# )

# HandCard.create(
#     :user_id => user2.id,
#     :card_id => rand(5..10)
# )    
# HandCard.create(
#     :user_id => user2.id,
#     :card_id => rand(10...20)
# )
# HandCard.create(
#     :user_id => user2.id,
#     :card_id => rand(20...79)
# )

# card_id_array = Array.new(4) { rand(1...79) }
# card_id_array.each do |card_id|
#     HandCard.new(
#         :user_id => user1
#         :card_id => card_id
#     )
cli = Interface.new
user_object = cli.welcome

while !user_object
  user_object = cli.welcome
end

cli.user = user_object

choice = cli.main_menu



binding.pry
puts "hello world"
