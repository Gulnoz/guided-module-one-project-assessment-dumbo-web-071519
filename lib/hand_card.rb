class HandCard < ActiveRecord::Base
    belongs_to :user
    belongs_to :card
end