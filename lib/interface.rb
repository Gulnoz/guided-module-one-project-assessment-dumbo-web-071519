class Interface 
    attr_accessor :prompt, :user

    def initialize()
      @prompt = TTY::Prompt.new
    end
end
