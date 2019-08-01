require_relative "./interface"

class User < ActiveRecord::Base
    has_many :hand_cards
    has_many :cards, through: :hand_cards
    attr_accessor :interface

    # def self.prompt 
    #     TTY::Prompt.new
    #     #Interface.new
    # end

    # def self.handle_returning_user
    #     puts "What is your name?"
    #     name = gets.chomp
        
    #     User.find_by(name: name)
    # end

    # def self.handle_new_user
    #     puts "What is your name?"
    #     name = gets.chomp
    #     puts "Enter your age?"
    #     age = gets.chomp
    #     puts "What's your relationship status?"
    #     relationship_status = gets.chomp
    #     User.create(name: name, age: age, relationship_status: relationship_status)
    # end

    # def handle_new_reading
    #     self.generate_hand_cards
    #     puts "generating your fortune...please stand by..."
    #     self.interface.list_hand_cards(get_last_hand)
    #     #Array of instanses of hand_cards present them like menu of cards 
    #     #to be abe to choise one
    #     #we get card_id wich was chosen and returning the card object from the hand_card table

    # end

    ##### if user wants to generate a new reading more than once in the same day
    ##### we will update the last four hand_cards, rather than creating four new instances
    ##### and that way we can keep track of the date in a cleaner fashion.
    

    def card_id_array
        self.get_last_hand.map do |hand_card|
            hand_card.card_id
        end
    end
  
    def find_hand_cards_by_datetime(date)
        self.hand_cards.select do |hand_card|
            hand_card.date == date
        end
    end
    #=> returns an array of hand_card objects

    def get_last_hand
        self.hand_cards.last(4)
    end #=> returns an array of hand_card objects
    
    def available_cards
        Card.all.select do |card|
            !self.card_id_array.include?(card.id)
        end
    end

    def update_hand_card(hand_card_id)
        HandCard.update(hand_card_id, :card_id => self.available_cards.sample.id)
    end

    
    def generate_hand_card
        available_card = self.available_cards.sample
        #binding.pry
        HandCard.create(user_id: self.id, card_id: available_card.id, date: Time.now.strftime("%m/%d/%Y"))
    end


    def generate_hand_cards
        if self.get_last_hand.length == 4 && self.get_last_hand[-4].date == Time.now.strftime("%m/%d/%Y")
            
            hand = get_last_hand.map do |hand_card|
                hand_card.id
            end
            self.update_hand_card(hand[0])
            self.update_hand_card(hand[1])
            self.update_hand_card(hand[2])
            self.update_hand_card(hand[3])
        else
            self.generate_hand_card
            self.generate_hand_card
            self.generate_hand_card
            self.generate_hand_card
        end
    end


    
    #menu of card information
    def reading_dates
        self.hand_cards.map do |hand_card|
            hand_card.date
       end.uniq #=> returns an array of dates as datetime
    end

    #TODO: work on this method so that it returns a TTY::Prompt.new.select menu for reading
    #the individual dates
    # def list_reading_dates
    #     system "clear"
    #     user_choice = ""
    #     while user_choice != "❌ EXIT ❌"
    #         #binding.pry
    #         user_choice = TTY::Prompt.new.select("🔮 #{self.name}, Select a date to view your past reading.") do |menu|
    #             reading_dates.map do |date|
    #                 menu.choice "#{date}", -> {handle_previous_reading_by_date(date)}
    #             end
    #             menu.choice "❌ EXIT ❌", -> {self.interface.main_menu}
    #         end
    #     end
    # end

    ## TODO: figure out Date object stuff

    #TODO: if user wants to draw two or more hands in one day
    ## we need to find_hand_by_date(todays date) and delete them
    ## and then generate_hand_cards with todays date
    
    ## TODO: swap card method
    ##  gets a card id from user
    ## updates that cards ID from available_cards 
    ##  hand_card.update.id (self.available_cards.sample.id)

    ## TODO: flush out Date logic 
    ## TODO: rollback DB, change datetime to date in hand_card migration file, and remigrate db

    ## TODO: CLI list cards for reading
    ## TODO: display card information
    

end