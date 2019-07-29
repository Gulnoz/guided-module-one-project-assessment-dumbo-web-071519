class Card < ActiveRecord::Base
    has_many :hand_cards
    has_many :users, through: :hand_cards
end