require 'singleton'
module MyMusicPlayer
  class Shell
    include Singleton

    def run(*commands)
      commands << :exit unless commands.empty?
      command = nil
      until command.to_s == 'exit'
        print 'mmp> '
        command = commands.shift || gets.strip
        if self.respond_to?("mmp_#{command}")
          send("mmp_#{command}")
        else
          puts "Unrecognized Command: #{command}"
        end
      end 
    end

    #######
    private
    #######

    def mmp_exit
      puts "Exiting..."
    end

  end
end
