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

    def handle_new_reading
        self.generate_hand_cards
        puts "generating your fortune...please stand by..."
        list_hand_cards(get_last_hand)
        #Array of instanses of hand_cards present them like menu of cards 
        #to be abe to choise one
        #we get card_id wich was chosen and returning the card object from the hand_card table

    end

    ##### if user wants to generate a new reading more than once in the same day
    ##### we will update the last four hand_cards, rather than creating four new instances
    ##### and that way we can keep track of the date in a cleaner fashion.

    def handle_previous_reading
        puts "finding your fortune...please stand by..."
        self.list_reading_dates
        #array of dates wich we need to make menu of selections fro user to select a date 
        #when user select the date from menu we we pass it(variable) to handle_previous_reading_by_date(selected_date)
    end
    
    def handle_previous_reading_by_date(selected_date)
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
        HandCard.create(user_id: self.id, card_id: available_card.id, date: Time.now.strftime("%m/%d/%Y"))
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
       user_command=""
        while user_command!="x"
        last_four_cards = self.get_last_hand.map do |hand_card| {
            name: hand_card.card.meaning_rev, value: hand_card.card_id
   
       } end
   
     selected_card_id = TTY::Prompt.new.select("These are your cards, #{self.name}. 
         Choose 1 to see more interpratation.", last_four_cards)
          card = Card.find(selected_card_id)
          card.display_information
        #lists the last four hand cards
        puts "To go to main-menu, press <X>. To continue press <Enter>."
        user_command=gets.chomp
       end
       cli = Interface.new
       cli.user = self
       cli.main_menu
    end
    
    def reading_dates
        self.hand_cards.map do |hand_card|
            hand_card.date
       end.uniq #=> returns an array of dates as datetime
    end

    #TODO: work on this method so that it returns a TTY::Prompt.new.select menu for reading
    #the individual dates
    def list_reading_dates
        chosen_dates = self.reading_dates.map do |reading_date| {
            name: reading_date, value: reading_date
           }end
            
            if chosen_dates.length>0
            selected_date = TTY::Prompt.new.select("These are your last readings date, #{self.name}. 
         Choose 1 to see more details.", chosen_dates)
         handle_previous_reading_by_date(selected_date)
            else
                puts "Nothing there.."
                
            end
            puts "To go to the main-menu press <X>"
            if gets.chomp == x
            cli = Interface.new
            cli.user = self
            cli.main_menu
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