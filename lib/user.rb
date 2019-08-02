require_relative "./interface"

class User < ActiveRecord::Base
    has_many :hand_cards
    has_many :cards, through: :hand_cards
    attr_accessor :interface


    def card_id_array
        self.get_last_hand.map do |hand_card|
            hand_card.card_id
        end
    end
  
    def find_hand_cards_by_datetime(date)
        self.hand_cards.select do |hand_card|
            hand_card.date == date
        end
    end #=> returns an array of hand_card objects

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
        HandCard.create(user_id: self.id, card_id: available_card.id, date: Time.now.strftime("%m/%d/%Y"))
    end

    #TODO: if user wants to draw two or more hands in one day
    ## get_last_hand and update each card with the available_cards.sample
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
    
    #TODO: work on this method so that it returns a TTY::Prompt.new.select menu for reading
    #the individual dates
    def reading_dates
        self.hand_cards.map do |hand_card|
            hand_card.date
       end.uniq #=> returns an array of dates as datetime
    end






    
 
    ## TODO: CLI list cards for reading
    ## TODO: display card information
    

end