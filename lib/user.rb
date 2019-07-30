class User < ActiveRecord::Base
    has_many :hand_cards
    has_many :cards, through: :hand_cards

    def self.handle_returning_user
    puts "What is your name?"
    name = gets.chomp
    User.find_by(name: name)
    end

    def self.handle_new_user
        puts "Welcome to my app. What is your name, traveler?"
        name = gets.chomp
        puts "Enter your age?"
        age = gets.chomp
        puts "Enter your age?"
        relationship_status = gets.chomp
        User.create(name: name, age: age, relationship_status: relationship_status)
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
end