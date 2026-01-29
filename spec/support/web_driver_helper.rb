# frozen_string_literal: true

# Provide a helper method to collect console logs in a test
module WebDriverHelper
  # rubocop:disable Metrics/MethodLength
  def collect_console_logs(page)
    page.execute_script <<~JS
      window.collectedLogs = [];
      window.collectedLogEntries = [];
      const originalConsoleError = console.error;
      const formatValue = (value) => {
        if (value === undefined) {
          return 'undefined';
        }
        if (value === null) {
          return 'null';
        }
        if (value instanceof Element) {
          return value.outerHTML;
        }
        if (typeof value === 'object') {
          try {
            return JSON.stringify(value);
          } catch (error) {
            return Object.prototype.toString.call(value);
          }
        }
        return String(value);
      };
      const formatMessage = (args) => {
        if (typeof args[0] !== 'string') {
          return args.map(formatValue).join(' ');
        }
        let formatted = args[0];
        let argIndex = 1;
        formatted = formatted.replace(/%[sdifoO]/g, () => {
          const value = args[argIndex];
          argIndex += 1;
          return formatValue(value);
        });
        if (argIndex < args.length) {
          formatted = [formatted, ...args.slice(argIndex).map(formatValue)].join(' ');
        }
        return formatted;
      };
      const storeLog = (level, args) => {
        const formatted = formatMessage(args);
        window.collectedLogs.push(formatted);
        window.collectedLogEntries.push({ level, args: args.map(formatValue) });
      };
      console.log = function(...args) {
        storeLog('log', args);
        originalConsoleLog.apply(console, args);
      };
      console.error = function(...args) {
        storeLog('error', args);
        originalConsoleError.apply(console, args);
      };
    JS
  end
  # rubocop:enable Metrics/MethodLength
end

RSpec.configure do |config|
  config.include WebDriverHelper
end
