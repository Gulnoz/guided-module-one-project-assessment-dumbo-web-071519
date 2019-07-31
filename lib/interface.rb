class Interface 
    attr_accessor :prompt, :user

    def initialize()
      @prompt = TTY::Prompt.new
    end

    def welcome
        puts "Welcome to the Toro Application!"
          answer = prompt.select("Have you been here before?") do |menu|
          menu.choice "NEW USER", -> {User.handle_new_user}
          menu.choice "RETURNING USER", -> {User.handle_returning_user}
        end
    end

    def main_menu
        system "clear"
        user.reload
        prompt.select("#{self.user.name}! are you ready to learn your fortune? Choose 4 cards, please.") do |menu|
          menu.choice "GET NEW READING", -> {self.user.handle_new_reading}
          menu.choice "ACCESS NEW READING", -> {self.user.handle_previous_reading}
          menu.choice "SETTINGS"
          # menu.choice "Update your information"
          # menu.choice "Delete a reading"
          # menu.choice "Delete yourself"
          menu.choice "EXIT", -> {self.exit_program}
        end
    end   

    def card_menu 
      #read name
      #read meaning reversed 
      #read description
    end
    
    #TODO: Create a card reading options menu

    def exit_program
          @prompt.say("Bye bish!")
          exit!
    end
    
end
