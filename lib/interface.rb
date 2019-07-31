class Interface 
    attr_accessor :prompt, :user

    def initialize()
      @prompt = TTY::Prompt.new
    end

    def welcome
        system "clear"
        puts "Welcome to the 🔮 Tarot 🔮 Application!"
          answer = prompt.select("Have you been here before?") do |menu|
          # menu.choice "🔮 NEW USER 🔮", -> {User.handle_new_user}
          # menu.choice "🔮 RETURNING USER 🔮", -> {User.handle_returning_user}
          menu.choice "🔮 LOGIN  🔮", -> {self.login}
          menu.choice "🔮 CREATE ACCOUNT 🔮", -> {self.create_new_user}          
          menu.choice "❌ EXIT ❌", -> {self.exit_program}
        end
    end

    def login
        system "clear"  
        puts "What is your name?"
        name = gets.chomp
        self.user = User.find_by(name: name)
        user.reload
        # ERIC
        self.main_menu
    end

    def create_new_user
        puts "What is your name?"
        name = gets.chomp
        puts "Enter your age?"
        age = gets.chomp
        puts "What's your relationship status?"
        relationship_status = gets.chomp
        user = User.create(name: name, age: age, relationship_status: relationship_status)
        self.user = user
    end

    def main_menu
        system "clear"
        user.reload
        prompt.select("#{self.user.name}! 🔮 🔮 🔮 Are you ready to read your fortune? 🔮 🔮 🔮 Choose 4 cards, please.") do |menu|
          menu.choice "🔮 GET NEW READING 🔮", -> {self.handle_new_reading}
          menu.choice "🔮 ACCESS PREVIOUS READING 🔮", -> {self.handle_previous_reading}
          menu.choice "🔮 SETTINGS 🔮", -> {self.settings_menu}
          # menu.choice "Update your information"
          # menu.choice "Delete a reading"
          # menu.choice "Delete yourself"
          #create a Settings menu 
          #allow user to exit the menu without exiting the program
          menu.choice "❌ EXIT ❌", -> {self.welcome}
        end
    end   

    def settings_menu
      system "clear"
      user.reload
      prompt.select("#{self.user.name}! 🔮 🔮 🔮 Please select a settings option. 🔮 🔮 🔮") do |menu|
          menu.choice "🔮 UPDATE NAME 🔮", -> {self.update_name}
          menu.choice "🔮 UPDATE BIRTHDAY 🔮", -> {self.update_birthday}
          menu.choice "🔮 UPDATE RELATIONSHIP STATUS 🔮", -> {self.update_relationship_status}
          menu.choice "🔮 DELETE YOURSELF 🔮", -> {self.delete_yourself}
          menu.choice "❌ EXIT ❌", -> {self.main_menu}
      end
    end

    def card_menu 
      #read name
      #read meaning reversed 
      #read description
    end


    def delete_reading(card_array)
      # system "clear"
      # user.reload
      card_array.each do |hand_card|
        hand_card.destroy
        #card_array.delete(hand_card)
      end
      # ERIC
      self.main_menu
    end

    #TODO: Create a card reading options menu

    def exit_program
          @prompt.say("Bye bish!")
          exit!
    end

    def handle_new_reading
        
        self.user.generate_hand_cards
        puts "generating your fortune...please stand by..."
        self.list_hand_cards(self.user.get_last_hand)
        #Array of instanses of hand_cards present them like menu of cards 
        #to be abe to choise one
        #we get card_id wich was chosen and returning the card object from the hand_card table

    end

    def handle_previous_reading
        puts "finding your fortune...🔮 🔮 🔮 please stand by...🔮 🔮 🔮"
        self.list_reading_dates
        #array of dates wich we need to make menu of selections fro user to select a date 
        #when user select the date from menu we we pass it(variable) to handle_previous_reading_by_date(selected_date)
    end
    


    #TODO: work on this method so that it returns a TTY::Prompt.new.select menu for reading
    #the individual dates
    def list_reading_dates
        system "clear"
        user_choice = ""
        # while user_choice != "❌ EXIT ❌" && user_choice != "🗑 DELETE READING 🗑" do
            
            user_choice = prompt.select("🔮 #{self.user.name}, Select a date to view your past reading.") do |menu|
                self.user.reading_dates.map do |date|
                    menu.choice "#{date}", -> {self.handle_previous_reading_by_date(date)}
                end
                menu.choice "❌ EXIT ❌", -> {self.main_menu}
            end
          # binding.pry
        # end
    end

    def handle_previous_reading_by_date(selected_date)
        puts "finding your fortune... 🔮 🔮 🔮 please stand by... 🔮 🔮 🔮"
        self.list_hand_cards(self.user.find_hand_cards_by_datetime(selected_date))
    end
    
    #TODO: work on this method so that it returns a TTY::Prompt.new.select menu for reading
    #the individual cards
    def list_hand_cards(card_array)
        #system "clear"
        user_choice = ""
        # while user_choice != "❌ EXIT ❌" && user_choice != "🗑 DELETE READING 🗑" do
             #self.reload
                user_choice = prompt.select("🔮 #{self.user.name}, Select a card to see more details.") do |menu|
                card_emoji_string = "🂠"
                crystal_ball_emoji_string = "🔮"
                card_array.map do |handCard|
                    menu.choice " 🂠 TAROT #{crystal_ball_emoji_string} 🂠 ", -> {Card.find(handCard.card.id).display_information}
                    card_emoji_string += "🂠"
                    crystal_ball_emoji_string += " 🔮"
                end
                menu.choice "🗑 DELETE READING 🗑", -> {self.delete_reading(card_array)}
                menu.choice "❌ EXIT ❌", -> {self.main_menu}
                end   
            
                      
                # binding.pry  
        # end 
        puts "user_choice = #{user_choice}"  
        
    end

    def update_name
        puts "What name would you like to have"
        name=gets.chomp
        User.update(self.user.id, :name => name)
        self.settings_menu
    end
    
    # HandCard.update(hand_card_id, :card_id => self.available_cards.sample.id)
    def update_birthday
        puts "Enter your birthday like (MM/DD/YYYY)."
        birthday=gets.chomp
        User.update(self.user.id, :birthday => birthday)
        self.settings_menu
    end
    
    def update_relationship_status
        puts "Enter your relationship status."
        puts "(It's ok, we've been there..)"
        status=gets.chomp
        User.update(self.user.id, :relationship_status => status)
        self.settings_menu
    end

    def delete_yourself
        puts "GoodBye!!! :("
        self.destroy
        self.main_menu
        
    end
    
end
