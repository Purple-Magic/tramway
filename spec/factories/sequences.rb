# frozen_string_literal: true

# include ActionDispatch::TestProcess

FactoryBot.define do
  sequence :string do |n|
    "string#{n}"
  end
  sequence :name do |n|
    "name#{n}"
  end
  sequence :address do |n|
    "street-#{n}"
  end
  sequence :short_string do |n|
    "str#{n}"
  end
  sequence :password do |_n|
    '123'
  end
  sequence :integer do |n|
    n
  end
  sequence :email do |n|
    "email_#{n}@mail.com"
  end
  sequence :url do |n|
    "http://site#{n}.com"
  end
  sequence :date do |n|
    Time.zone.today + n.day
  end
  sequence :colour do
    (1..6).reduce('') { |str| str + (('a'..'f').to_a + ('0'..'9').to_a).sample }
  end
  sequence :filename do |n|
    "file#{n}.png"
  end
  sequence :image_as_file do |_n|
    fixture_file_upload('public/temp.png', 'image/png')
  end
  sequence :latitude do |_n|
    rand(-90.0..90.0)
  end
  sequence :longitude do |_n|
    rand(-180.0..180.0)
  end
  sequence :phone do |_n|
    '+71234567890'
  end
  sequence :birthdate do |_n|
    rand(10..100).year.ago
  end
  sequence :zipcode do |n|
    "#{"#{n}000"[0, 3]}AH"
  end
end
