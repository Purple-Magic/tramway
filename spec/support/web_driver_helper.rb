# frozen_string_literal: true

# Provide a helper method to collect console logs in a test
module WebDriverHelper
  # :reek:UtilityFunction { enabled: false }
  def collect_console_logs(page)
    page.execute_script <<~JS
      window.collectedLogs = [];
      const originalConsoleLog = console.log;
      console.log = function(message) {
        window.collectedLogs.push(message);
        originalConsoleLog.apply(console, arguments);
      };
    JS
  end
  # :reek:UtilityFunction { enabled: true }
end

RSpec.configure do |config|
  config.include WebDriverHelper
end
