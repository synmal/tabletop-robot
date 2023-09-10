require './tabletop'
require './robot'
require 'thor'
require 'tty-prompt'
require 'debug'

class RobotTabletop < Thor
  desc "Play", "Play Robot Tabletop"
  def play
    @prompt = TTY::Prompt.new
    @tabletop = setup_tabletop
    @robot = Robot.new(tabletop: @tabletop)

    until @robot.placed? do
      prompt_robot_placement
    end

    robot_actions
  end

  desc "Play From File", "Play Robot Tabletop. Robot commands are imported from file"
  def play_from_file(file_path)
    @prompt = TTY::Prompt.new
    @tabletop = setup_tabletop
    @robot = Robot.new(tabletop: @tabletop)

    commands = File.foreach(file_path).map { |cmd| cmd.chomp }
    commands.each do |cmd|
      commands_parser(cmd)
    end
  end

  def self.exit_on_failure?
    true
  end

  private
    def setup_tabletop
      width = @prompt.ask 'Please input tabletop width:', required: true, convert: :int
      height = @prompt.ask 'Please input tabletop height:', required: true, convert: :int
      Tabletop.new(width: width, height: height)
    end

    def prompt_robot_placement
      @prompt.say 'Setting up robot placement on tabletop'

      placement_prompt = -> (robot) {
        @prompt.collect do
          key(:x).ask('X position of the robot', required: true, convert: :int) do |q|
            q.in "0-#{robot.tabletop.width - 1}"
          end

          key(:y).ask('Y position of the robot', required: true, convert: :int) do |q|
            q.in "0-#{robot.tabletop.height - 1}"
          end

          key(:facing).select('Robot facing', required: true) do |menu|
            menu.choice 'North', 'north'
            menu.choice 'East', 'east'
            menu.choice 'South', 'south'
            menu.choice 'West', 'west'
          end
        end
      }

      placement = placement_prompt.call(@robot)

      @robot.place(**placement)
    end

    def robot_actions
      prompt_string = <<~STRING
      Input actions for your robot.
      Valid commands
      PLACE x,y,facing (eg. PLACE 1,1,north)
      LEFT (Turns the robot left)
      RIGHT (Turns the robot right)
      MOVE (Move robot forward from the direction that it is currently facing)
      REPORT (Get current coordinates and facing of the robot)
      STRING

      user_prompt = @prompt.ask prompt_string, required: true do |q|
        q.modify :trim
      end

      system("clear") || system("cls")

      commands_parser(user_prompt)

      robot_actions
    end

    def commands_parser(command)
      case command
      when /\APLACE/
        regex = /\A(PLACE)(.*)\z/
        coordinates = command.match(regex)[2]
        stripped_coordinates = coordinates.gsub(/[[:space:]]/, '')
        x, y, facing = stripped_coordinates.split(',')
        @robot.place(x: x.to_i, y: y.to_i, facing: facing)
      when /\ALEFT/
        @robot.left
      when /\ARIGHT/
        @robot.right
      when /\AMOVE/
        @robot.move
      when /\AREPORT/
        @robot.report
      end
    end
end

RobotTabletop.start ARGV
