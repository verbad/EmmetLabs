module Spec
  module DSL
    module BehaviourEval
      module ModuleMethods
        def xit(spec_name)
          $stderr.puts "#{colorize('WARNING:', :yellow, :blink)} Specification \"#{spec_name}\" disabled!  Don't check this in!"
        end
      end
    end
  end
end

module Output
  module Colorizations
    def colorize(text, color, format=nil)
      color_code = format.nil? ? "\e[#{colors[color]}m" : "\e[#{formats[format]};#{colors[color]}m"
      "#{color_code}#{text}\e[0m"
    end

    def formats
      {
        :bright => 1,
        :underline => 4,
        :blink => 5,
        :hide => 8
      }
    end

    def colors
      {
        :off => 0,
        :swap => 7,
        :black => 30,
        :red => 31,
        :green => 32,
        :yellow => 33,
        :blue => 34,
        :magenta => 35,
        :cyan => 36,
        :white => 37,
        :default => 39
      }
    end
  end
end

include Output::Colorizations

