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

  def tramway_autocomplete(option, from:)
    id = "#{from.split('[').join('_').chomp(']')}_tramway_select"
    find("div##{id}[role='combobox']").click

    input = find("input[data-action='input->tramway-select#search']", visible: false)
    input.send_keys(option)

    find('div.option', text: /#{option}/).click
  rescue StandardError
    find("div##{id}[role='combobox']").click
  end
end
