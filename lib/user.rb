class User < ActiveRecord::Base
has_many :hand_cards
has_many :cards, through :hand_cards
 end