class Card < ActiveRecord::Base
    has_many :hand_cards
    has_many :users, through: :hand_cards

    def display_information
      system "clear"
      puts "Type: #{self.card_type}"
      puts "Short Name: #{self.name_short}"
      puts "Name: #{self.name}"
      puts "Value: #{self.value_int}"
      puts "Suit: #{self.suit}"
      puts "Description: #{self.desc}"
    end

    def display_type
      puts "Type:".red
      puts self.card_type
    end

    def display_name
      puts "Name:".red
      puts self.name
    end

    def display_value
      puts "Value:".red
      puts  self.value_int
    end

    def display_suit
      puts "Suit:".red
      puts  self.suit
    end


    def display_description
      count=0
      new_str=""
      arr=self.desc.split(" ")
      arr.map do |word|
        if count>10
        new_str+=word+"\n"+" "
        count=0
        else
          new_str+=word+" "
          count+=1
        end
        
      end
      puts "Description:".red
      puts new_str
    end
    
end