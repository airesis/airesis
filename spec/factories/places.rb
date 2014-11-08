FactoryGirl.define do
  factory :place do
    comune { Comune.all.sample }
    address { Faker::Address.street_name }
    civic_number { Faker::Address.building_number }
    cap { '12345' }
    latitude_original { Faker::Address.latitude }
    longitude_original { Faker::Address.longitude }
    latitude_center { Faker::Address.latitude }
    longitude_center { Faker::Address.longitude }
    zoom 5
  end
end
