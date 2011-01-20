module Spec
  module Rails
    module DSL
      module AllBehaviourHelpers
        def response_code_should_be(sym)
          response.should have_response_code(sym)
        end
      end
    end
  end
end
