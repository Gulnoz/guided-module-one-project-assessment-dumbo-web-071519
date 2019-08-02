class Interface 
    attr_accessor :prompt, :user

    def initialize()
      @prompt = TTY::Prompt.new
      @font = TTY::Font.new(:doom)
    end

    def welcome
        system "clear"
        puts @font.write("TOROT",letter_spacing: 4).red
        puts "Welcome to the 🔮 Tarot 🔮 Application!"
          answer = prompt.select("Have you been here before?") do |menu|
          menu.choice "🔮 LOGIN  🔮", -> {self.login}
          menu.choice "🔮 CREATE ACCOUNT 🔮", -> {self.create_new_user}          
          menu.choice "❌ EXIT ❌", -> {self.exit_program}
        end
    end

    def login
        system "clear"  
        user_name = prompt.ask("What is your name?")
        user_password = prompt.mask("What is your password?")
        user_obj=User.find_by(name: user_name, password: user_password)
        if user_obj!=nil
          self.user = user_obj
          user.reload
          # ERIC
          self.main_menu
        else
            answer = prompt.select("There is no user with this name, please try again.") do |menu|
              menu.choice "🔮 Try again  🔮", -> {self.login}
              menu.choice "⬅️ Back ⬅️" , -> {self.welcome}
          end
        end
    end

    def create_new_user
        name=prompt.ask("What's your name?")
        password=prompt.mask("Create password:")
        age=prompt.ask("Enter your age?")
        status=prompt.ask("What's your relationship status?")
        prompt.select("") do |menu|
            menu.choice "Save" , -> {self.create_user(name,password,age,status)}
            menu.choice "⬅️ Back ⬅️" , -> {self.welcome}
          end
    end

     def create_user(user_name,user_password,user_age,user_status)
        user = User.create(name: user_name,password: user_password, age: user_age, relationship_status: user_status)
        self.user = user
        self.main_menu
     end
    def main_menu
        system "clear"
        user.reload
        prompt.select("#{self.user.name}! 🔮 🔮 🔮 Are you ready to read your fortune? 🔮 🔮 🔮 Choose 4 cards, please.") do |menu|
          menu.choice "🔮 GET NEW READING 🔮", -> {self.handle_new_reading}
          menu.choice "🔮 ACCESS PREVIOUS READING 🔮", -> {self.handle_previous_reading}
          menu.choice "🔮 SETTINGS 🔮", -> {self.settings_menu}
          menu.choice "⬅️ Back ⬅️", -> {self.welcome}
        end
    end   

    def settings_menu
      system "clear"
      user.reload
      prompt.select("#{self.user.name}! 🔮 🔮 🔮 Please select a settings option. 🔮 🔮 🔮") do |menu|
      menu.choice "🔮 VIEW INFO 🔮", -> {self.display_info}
          menu.choice "🔮 UPDATE NAME 🔮", -> {self.update_name}
          menu.choice "🔮 UPDATE PASSWORD 🔮", -> {self.update_password}
          menu.choice "🔮 UPDATE BIRTHDAY 🔮", -> {self.update_birthday}
          menu.choice "🔮 UPDATE RELATIONSHIP STATUS 🔮", -> {self.update_relationship_status}
          menu.choice "🔮 DELETE YOURSELF 🔮", -> {self.delete_yourself}
          menu.choice "⬅️ Back ⬅️", -> {self.main_menu}
      end
    end

    def display_info
      prompt.select("") do |menu|
      puts "NAME: #{self.user.name}"
      puts "PASSWORD: #{self.user.password}"
      puts "BIRTHDAY: #{self.user.birthday}"
      puts "RELATIONSHIP STATUS:  #{self.user.relationship_status}"
      menu.choice "⬅️ Back ⬅️", -> {self.settings_menu}
    end
    end
    def delete_reading(card_array)
      # system "clear"
      # user.reload
      card_array.each do |hand_card|
        hand_card.destroy
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
                menu.choice "⬅️ Back ⬅️", -> {self.main_menu}
            end
        # end
        
    end

    def handle_previous_reading_by_date(selected_date)
        puts "finding your fortune... 🔮 🔮 🔮 please stand by... 🔮 🔮 🔮"
        self.list_hand_cards(self.user.find_hand_cards_by_datetime(selected_date))
    end
    
    #TODO: work on this method so that it returns a TTY::Prompt.new.select menu for reading
    #the individual cards
    def list_hand_cards(card_array)        
        user_choice = ""
         while user_choice != "⬅️ BACK ⬅️" && user_choice != "🗑 DELETE READING 🗑" do
             #self.reload
                user_choice = prompt.select("🔮 #{self.user.name}, Select a card to see more details.") do |menu|
                card_emoji_string = "🂠"
                crystal_ball_emoji_string = "🔮"
                card_array.map do |handCard|
                  string=" 🂠 TAROT #{crystal_ball_emoji_string} 🂠 "
                    menu.choice " 🂠 TAROT #{crystal_ball_emoji_string} 🂠 ", -> {reading_card(handCard.card, card_array,string); " 🂠 TAROT #{crystal_ball_emoji_string} 🂠 "}
                    # menu.choice " 🂠 TAROT #{crystal_ball_emoji_string} 🂠 ", -> {self.reading_card(Card.find(handCard.card_id))}
                    card_emoji_string += "🂠"
                    crystal_ball_emoji_string += " 🔮"
                end
                menu.choice "🗑 DELETE READING 🗑", -> {self.delete_reading(card_array); "🗑 DELETE READING 🗑"}
                menu.choice "⬅️ BACK ⬅️", -> {self.main_menu;"⬅️ BACK ⬅️"}
                end   
         end 
    end

  def reading_card(card_obj, card_array, card_string)
      system "clear"
      puts card_string
      user_choice = ""
      while user_choice != "⬅️ BACK ⬅️" do
        user_choice = prompt.select("🔮 #{self.user.name}, please choose from the list below.") do |menu|
          menu.choice  "🔮 READ TYPE 🔮", -> {card_obj.display_type}
          menu.choice "🔮 READ NAME 🔮", -> {card_obj.display_name}
          menu.choice "🔮 READ VALUE 🔮", -> {card_obj.display_value}
          menu.choice  "🔮 READ DESCRIPTION 🔮", -> {card_obj.display_description}
          menu.choice "⬅️ BACK ⬅️", -> {self.list_hand_cards(card_array); "⬅️ BACK ⬅️"}
        end
      end
  end

    def update_name
        name =  prompt.ask("What name would you like to have?")
        #name=gets.chomp
        User.update(self.user.id, :name => name)
        self.settings_menu
    end
    def update_password
      password =  prompt.ask("Enter new password.")
      #name=gets.chomp
      User.update(self.user.id, :password => password)
      self.settings_menu
  end
    
    # HandCard.update(hand_card_id, :card_id => self.available_cards.sample.id)
    def update_birthday
        name = prompt.ask("Enter your birthday like (MM/DD/YYYY).")
        #birthday=gets.chomp
        User.update(self.user.id, :birthday => birthday)
        self.settings_menu
    end
    
    def update_relationship_status
        puts("Enter your relationship status.")
        status = prompt.ask("(It's ok, we've been there..)") 
        status=gets.chomp
        User.update(self.user.id, :relationship_status => status)
        self.settings_menu
    end

    def delete_yourself
        #puts "Goodbye #{self.user.name}!!! :( "  
        self.user.hand_cards.each do |hand_card|
          hand_card.destroy
        end
        self.user.destroy
        self.welcome
        
        
    end
    
end
