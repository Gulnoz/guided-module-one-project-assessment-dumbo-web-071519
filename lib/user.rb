class User < ActiveRecord::Base
    has_many :hand_cards
    has_many :cards, through: :hand_cards
<<<<<<< HEAD
    
=======

    def self.handle_returning_user
    puts "What is your name?"
    name = gets.chomp
    User.find_by(name: name)
    end

    def self.handle_new_user
        puts "Welcome to my app. What is your name, traveler?"
        name = gets.chomp
        User.create(name: name)
    end

    def list_hand_cards
        # # [<TEAM>, <TEAM>] => [{team1Name}, {team2Name}]
        # team_names = self.teams.map do |team|
        # {name: team.name, value: team.id}
        # end
        # team_id = TTY::Prompt.new.select("These are the teams for #{self.name}. Choose 1 to see more details.", team_names)
        # team = Team.find(team_id)
        # team.list_members
    end
>>>>>>> 1f1d347138aa2f4ed9f910fa07f7116fcfc11d86
end