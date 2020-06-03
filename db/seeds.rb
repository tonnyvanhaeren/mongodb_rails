### seeding data

user = User.create!(
  firstName: 'Antonius',
  lastName: 'Vanhaeren',
  email: 'antonius.vanhaeren@telenet.be',
  password: '1Telindus',
  is_email_verified: true,
  is_accepted: true
)

user1 = User.create!(
  firstName: 'Bonny',
  lastName: 'Vanhaeren',
  email: 'bonny.vanhaeren@telenet.be',
  password: '1Telindus',
  is_email_verified: true,
  is_accepted: false
)

pp "User created #{user.firstName} #{user.lastName}"
pp "User created #{user1.firstName} #{user1.lastName}"