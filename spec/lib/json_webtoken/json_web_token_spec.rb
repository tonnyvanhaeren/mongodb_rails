require 'rails_helper'

describe JsonWebToken do
  let(:andries) { build :user, email: 'bob.andries@telenet.be', lastName: 'Andries', password: '1Telindus' }

  subject { described_class.encode( id: andries._id, email: andries.email, role: andries.role ) }

  after(:context) do
    User.delete_all 
  end ### clean database  
  
  describe '#encode and decode' do
    it 'return a jwt token' do
      token = subject
      expect(subject).to eq(token)

      payload = described_class.decode(token)

      expect(payload).to include({email: 'bob.andries@telenet.be'})
      expect(payload).to include({role: 'user'})
    end

  end

end