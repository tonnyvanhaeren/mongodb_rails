require 'rails_helper'

describe JsonWebToken do
  let(:andries) { build :user, email: 'bob.andries@telenet.be', lastName: 'Andries', password: '1Telindus' }

  after(:context) do
    User.delete_all 
  end ### clean database  

  context '#encode - decode not expired' do
    subject { described_class.encode( { id: andries._id, email: andries.email, role: andries.role } ) }
    let(:token) { subject }

    it 'return a jwt token' do
      expect(subject).to eq(token)
    end

    it 'includes in payload exp email role id' do
      expect(described_class.decode(token)).to include(
        {
          exp: described_class.decode(token)[:exp],
          email: 'bob.andries@telenet.be',
          role: 'user'
        }
      )
    end    
  end

  context '#encode - decode (token expired)' do
    subject { described_class.encode( { id: andries._id, email: andries.email, role: andries.role }, Time.now.ago(6000) ) }
    let(:token) { subject }
    
    it 'return a jwt token' do
      expect(subject).to eq(token)
    end

    it 'raise Jwt Expired Signature error' do
      expect { described_class.decode(token) }.to raise_error(JWT::ExpiredSignature)
    end    
  end
    ## exp: Time.now.to_i + 4 * 3600
end