require "timeout"

module WaitSteps
  extend RSpec::Matchers::DSL

  matcher :become_true do
    match do |block|
      begin
        Timeout.timeout(10) do
          loop do
            value = block.call
            break if value == true
          end
        end
        true
      rescue TimeoutError
        false
      end
    end
  end
end
