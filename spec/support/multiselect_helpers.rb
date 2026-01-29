# frozen_string_literal: true

module MultiselectHelpers
  def multiselect(*options, from:)
    id = "#{from.split('[').join('_').chomp(']')}_multiselect"
    find("div##{id}[role='combobox']").click

    options.each do |option|
      find('div.option', text: /#{option}/).click
    rescue StandardError
      find("div##{id}[role='combobox']").click
      find('div.option', text: /#{option}/).click
    end
  end
end
