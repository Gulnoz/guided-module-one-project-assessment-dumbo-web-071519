class Card < ActiveRecord::Base
    has_many :hand_cards
    has_many :users, through: :hand_cards

    def display_information
      puts "Type: #{self.card_type}"
      puts "Short Name: #{self.name_short}"
      puts "Name: #{self.name}"
      puts "Value: #{self.value_int}"
      puts "Suit: #{self.suit}"
      puts "Description: #{self.desc}"
    end

    def display_type
      puts "Type: #{self.card_type}"
    end

    def display_name
      puts "Name: #{self.name}"
    end

    def display_value
      puts "Value: #{self.value_int}"
    end

    def display_suit
      puts "Suit: #{self.suit}"
    end


    def display_description
      puts "Description: #{self.desc}"
    end
    
end