module Test
  module Unit
    module UI
      module Console
        class QuickFeedbackRunner < TestRunner
          def add_fault(fault)
            super(fault)
            nl
            output fault.long_display
          end

          def finished(elapsed_time)
            nl
            output("Finished in #{elapsed_time} seconds.")
            nl
            output(@result)
          end
        end
      end
    end
  end
end

Test::Unit::AutoRunner::RUNNERS[:console] = proc do |r|
  Test::Unit::UI::Console::QuickFeedbackRunner
end
