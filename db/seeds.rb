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

user2 = User.create!(
  firstName: 'Albert',
  lastName: 'Vermeulen',
  email: 'albert.vermeulen@telenet.be',
  password: '1Telindus',
  is_email_verified: true,
  is_accepted: false
)

user3 = User.create!(
  firstName: 'Jozef',
  lastName: 'Michielsen',
  email: 'jos.michielsen@telenet.be',
  password: '1Telindus',
  is_email_verified: true,
  is_accepted: false
)


pp "User created #{user.firstName} #{user.lastName}"
pp "User created #{user1.firstName} #{user1.lastName}"
pp "User created #{user2.firstName} #{user2.lastName}"
pp "User created #{user3.firstName} #{user3.lastName}"