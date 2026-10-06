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

  def tramway_autocomplete(*options, from:)
    id = "#{from.split('[').join('_').chomp(']')}_tramway_select"
    find("div##{id}[role='combobox']").click

    options.each { |option| tramway_autocomplete_select_one(id, option) }
  end

  # The search input is recreated after every selection (so multi-select autocomplete can keep
  # filtering from a clean slate), so it must be looked up again for each option.
  def tramway_autocomplete_select_one(id, option)
    input = find("div##{id} input[data-action='input->tramway-select#search']", visible: false)
    input.send_keys(option)

    find('div.option', text: /#{option}/).click
  rescue StandardError
    find("div##{id}[role='combobox']").click
    tramway_autocomplete_select_one(id, option)
  end
end
