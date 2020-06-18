require 'rails_helper'

describe JsonWebToken do
  let(:andries) { build :user, email: 'bob.andries@telenet.be', lastName: 'Andries', password: '1Telindus' }
  
  subject { described_class.encode( id: andries._id, email: andries.email, role: andries.role ) }
  let(:token) { subject }

  after(:context) do
    User.delete_all 
  end ### clean database  
  
  describe '#encode and decode jwt token' do
    it 'return a jwt token' do
      expect(subject).to eq(token)
    end

    it 'includes in payload expiration email role id' do
      expect(described_class.decode(token)).to include(
        {
          expiration: described_class.decode(token)[:expiration],
          email: 'bob.andries@telenet.be',
          role: 'user'
        }
      )
    end


  end

end