### seeding data
### clean up

User.delete_all

user = User.new(
  firstName: 'Antonius',
  lastName: 'Vanhaeren',
  email: 'antonius.vanhaeren@telenet.be',
  password: '1Telindus',
  is_email_verified: true,
  is_accepted: true,
  role: :admin
)

user.save!
found_user = User.find_by(email: 'antonius.vanhaeren@telenet.be')
found_user.email_confirmation_ok

user1 = User.new(
  firstName: 'Bonny',
  lastName: 'Vanhaeren',
  email: 'bonny.vanhaeren@telenet.be',
  password: '1Telindus',
  is_email_verified: true,
  is_accepted: false
)

user1.save!
found_user = User.find_by(email: 'bonny.vanhaeren@telenet.be')
found_user.email_confirmation_ok

user2 = User.new(
  firstName: 'Albert',
  lastName: 'Vermeulen',
  email: 'albert.vermeulen@telenet.be',
  password: '1Telindus',
  is_email_verified: true,
  is_accepted: false
)

user2.save!
found_user = User.find_by(email: 'albert.vermeulen@telenet.be')
found_user.email_confirmation_ok

user3 = User.new(
  firstName: 'Jozef',
  lastName: 'Michielsen',
  email: 'jos.michielsen@telenet.be',
  password: '1Telindus',
  is_email_verified: false,
  is_accepted: false
)
user3.save!


pp "User  #{user.firstName} #{user.lastName} created"
pp "User  #{user1.firstName} #{user1.lastName} created"
pp "User  #{user2.firstName} #{user2.lastName} created"
pp "User  #{user3.firstName} #{user3.lastName} created"