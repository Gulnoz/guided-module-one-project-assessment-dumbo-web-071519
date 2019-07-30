class User < ActiveRecord::Base
    has_many :hand_cards
    has_many :cards, through: :hand_cards

    def self.handle_returning_user
        puts "What is your name?"
        name = gets.chomp
        User.find_by(name: name)
    end

    def self.handle_new_user
        puts "What is your name?"
        name = gets.chomp
        puts "Enter your age?"
        age = gets.chomp
        puts "What's your relationship status?"
        relationship_status = gets.chomp
        User.create(name: name, age: age, relationship_status: relationship_status)
    end

    def self.handle_new_reading
        self.generate_hand_cards
        puts "generating your fortune...please stand by..."
        list_hand_cards(get_last_hand)
    end

    ##### if user wants to generate a new reading more than once in the same day
    ##### we will update the last four hand_cards, rather than creating four new instances
    ##### and that way we can keep track of the date in a cleaner fashion.

    def self.handle_previous_reading
        puts "finding your fortune...please stand by..."
        self.list_reading_dates
    end
    
    def self.handle_previous_reading_by_date(selected_date)
        puts "finding your fortune...please stand by..."
        list_hand_cards(find_hand_cards_by_datetime(selected_date))
    end

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

    def generate_hand_card
        available_card = self.available_cards.sample
        #binding.pry
        HandCard.create(user_id: self.id, card_id: available_card.id)
    end


    def generate_hand_cards
        self.generate_hand_card
        self.generate_hand_card
        self.generate_hand_card
        self.generate_hand_card
    end

    #TODO: work on this method so that it returns a TTY::Prompt.new.select menu for reading
    #the individual cards
    def list_hand_cards(card_array)
    #    card_ids = self.hand.map do |hand_card| {
    #         #hand_card_id: "TAROT #{hand_card.id}", value: hand_card.card_id
    #         hand_card_id: hand_card.id, value: hand_card.card_id
    #    } end
    #    binding.pry
    #     #print 
    #     selected_card_id = TTY::Prompt.new.select("These are your cards, #{self.name}. 
    #     Choose 1 to see more details.", card_ids)
    #     # team = Team.find(team_id)
    #     card = Card.find(selected_card_id)
    #     card.display_information
    #     #lists the last four hand cards

    end
    
    def reading_dates
        self.hand_cards.map do |hand_card|
            hand_card.date
       end.uniq #=> returns an array of dates as datetime
    end

    #TODO: work on this method so that it returns a TTY::Prompt.new.select menu for reading
    #the individual dates
    def list_reading_dates
        self.reading_dates.each do |reading_date|
            puts reading_date
        end
    end

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