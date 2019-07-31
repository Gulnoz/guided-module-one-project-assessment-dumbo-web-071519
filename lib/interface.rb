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
        prompt.select("#{self.user.name}! are you ready to learn your fortune? Choose 4 cards, please.") do |menu|
          menu.choice "New fortune reading", -> {self.user.handle_new_reading}
          menu.choice "See previous readings", -> {self.user.handle_previous_reading}
          menu.choice "Update your information"
          menu.choice "Delete a reading"
          menu.choice "Delete yourself"
          menu.choice "Exit", ->{self.welcome}
        end
        
      end
end
