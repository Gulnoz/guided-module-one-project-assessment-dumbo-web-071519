class Interface 
    attr_accessor :prompt, :user

    def initialize()
      @prompt = TTY::Prompt.new
    end
    def welcome
        puts "Welcome to the Hero Application! 💪"
          answer = prompt.select("Are you a returning user or are you a new user?") do |menu|
          menu.choice "New User", -> {User.handle_new_user}
          menu.choice "Returning User", -> {User.handle_returning_user}
        end
    end

    def main_menu
        system "clear"
        user.reload
        prompt.select("Welcome #{self.user.name}! What would you like to do today?") do |menu|
          menu.choice "See All Teams", -> {self.user.list_teams}
          menu.choice "See All Heros"
          menu.choice "Create a Team"
          menu.choice "Edit a Team"
        end
      end
end
