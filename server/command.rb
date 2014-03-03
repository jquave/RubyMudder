require './player.rb'
class Command
  attr_accessor :name, :response, :needs_arg

  def initialize args
    needs_arg = false # Default
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
    puts 'Command added: '+name
  end

  def process(arg, current_user)
    if(name=='nick')
      #current_user.name=arg
      #puts current_user
      #current_user.save
      return "Name changed to #{arg}"
    end
    if(name=='say')
      return 'You call the small dog, "Come here, Bean!"'
    end
  end

  def needs_arg?
    needs_arg
  end

  # The resultant string to send the player upon completion
  def result(arg, current_user)
   puts 'Get result' 
    if arg.nil?
      puts 'Nil arg'
      if needs_arg?
        puts 'no arg'
        return 'Oops, did you forget to specify something?'
      else
        puts 'do resp'
        return response
      end
      return
    else
      # Has arg
      puts 'Has arg'
      if needs_arg?
        return process(arg, current_user)
      else
        return response
      end
    end
  end

end
