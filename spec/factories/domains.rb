FactoryBot.define do
  factory :domain do
    name { 'google.com' }
    # name { 'sha256.badssl.com' }
    trait :naim_with_error do
      name { 'expired.badssl.com' }
    end
  end
end