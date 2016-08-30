class IMS_Loop
  def self.runLoop
    usr_command=gets.chomp
    while (usr_command.capitalize) != "Exit"
      command_len=usr_command.length
      Command.respond(usr_command,command_len)
      usr_command=gets.chomp
    end
  end
end
