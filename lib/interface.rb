class Interface 
    attr_accessor :prompt, :user

    def initialize()
      @prompt = TTY::Prompt.new
    end
    def welcome
        puts "Welcome to the Toro Application!"
          answer = prompt.select("Have you been here before?") do |menu|
          menu.choice "New User", -> {User.handle_new_user}
          menu.choice "Returning User", -> {User.handle_returning_user}
        end
    end

    def main_menu
        system "clear"
        user.reload
        prompt.select("Welcome #{self.user.name}! are you ready to learn your fortune? Choose 4 cards, please.") do |menu|
          menu.choice "See All Teams", -> {self.user.list_teams}
          menu.choice "See All Heros"
          menu.choice "Create a Team"
          menu.choice "Edit a Team"
          
        end
      end
end
