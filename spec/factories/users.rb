FactoryBot.define do
  factory :user do
    email { 'test@test.com' }
    firstName { "antonius" }
    lastName { "vanhaeren" }
    is_email_verified { false }
    is_accepted { false }
  end
end
