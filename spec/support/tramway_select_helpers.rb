# frozen_string_literal: true

module TramwaySelectHelpers
  def tramway_select(*options, from:)
    id = "#{from.split('[').join('_').chomp(']')}_tramway_select"
    find("div##{id}[role='combobox']").click

    options.each do |option|
      find('div.option', text: /#{option}/).click
    rescue StandardError
      find("div##{id}[role='combobox']").click
      find('div.option', text: /#{option}/).click
    end
  end
end
