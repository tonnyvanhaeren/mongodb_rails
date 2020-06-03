FactoryBot.define do
  factory :user do
    ### email { 'test@test.com' }
    
    sequence :email do |n|
      "person#{n}@example.com"
    end

    firstName { "antonius" }
    lastName { "vanhaeren" }
    is_email_verified { false }
    is_accepted { false }
    password { "password" }
  end
end
