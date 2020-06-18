require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'factory' do
    subject { build :user, password: '1Telindus' }

    it { is_expected.to be_valid }
  end

  describe '#validation' do
    let(:user) { build :user, password: nil }

    context 'attribute password' do
      it 'validate presence' do
        expect(user).not_to be_valid
        expect(user.errors.messages[:password]).to include("can't be blank")
      end
    end

    context 'attributes firsName - lastName' do
      let(:user) { build :user, password: '1Telindus', firstName: nil, lastName: nil }  

      it 'validate presence' do
        expect(user).not_to be_valid
        expect(user.errors.messages[:firstName]).to include("can't be blank", "is too short (minimum is 2 characters)")
        expect(user.errors.messages[:lastName]).to include("can't be blank", "is too short (minimum is 2 characters)")
      end
    end

    context 'attributes firsName -lastName' do
      let(:user) { build :user, password: '1Telindus',
                                firstName: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
                                lastName: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' 
      }  

      it 'validate length < 50' do
        expect(user).not_to be_valid
        expect(user.errors.messages[:firstName]).to include("is too long (maximum is 50 characters)")
        expect(user.errors.messages[:lastName]).to include("is too long (maximum is 50 characters)")
      end
    end

    context 'attribute email' do
      let(:user) { build :user, password: '1Telindus', email: nil }  

      it 'validate presence' do
        expect(user).not_to be_valid
        expect(user.errors.messages[:email]).to include("can't be blank")
      end
    end

    context 'attribute email' do
      let(:user) { build :user, password: '1Telindus', email: 'opa@opa' }  

      it 'validate email format' do
        expect(user).not_to be_valid
        expect(user.errors.messages[:email]).to include("Invalid email format")
      end
    end

    context 'attribute email' do
      let(:user) { build :user, password: '1Telindus', email: 'opa@opa.be' }  

      it 'validate correct email format' do
        expect(user).to be_valid
      end
    end    

    context 'attribute email' do
      let(:user) { create :user, password: '1Telindus', email: 'opa@opa.be' }  
      let(:user_with_same_email) { build :user, password: '1Telindus', email: 'opa@opa.be' }  

      it 'validate the uniqueness' do
        expect(user).to be_valid
        expect(user_with_same_email).not_to be_valid
        expect(user_with_same_email.errors.messages[:email]).to include("Email is already in use")
        ## clean up database
        user.delete
      end
    end  
  end

  describe '#scopes' do
    after { described_class.delete_all }

    let(:andries) {{ is_email_verified: true, is_accepted: true, lastName: 'Andries' }}
    let(:bonapart) {{ is_email_verified: false, is_accepted: false, lastName: 'Bonapart' }}

    subject {
      create :user, andries
      create :user, bonapart
    }

    it 'should only return email verified users' do
      subject
      expect(described_class.email_verified.count).to be(1)
      expect(described_class.email_verified.first.lastName).to eq(andries[:lastName])
      expect(described_class.email_verified.first.lastName).not_to eq(bonapart[:lastName])
    end

    it 'should only return accepted users' do
      subject
      expect(described_class.accepted.count).to be(1)
      expect(described_class.accepted.first.lastName).to eq(andries[:lastName])
      expect(described_class.accepted.first.lastName).not_to eq(bonapart[:lastName])      
    end
  end

  describe '#authenticate' do
    it 'with valid password' do
      user = build :user , password: '1Telindus'
      expect(user).to be_valid
      expect(user.authenticate('1Telindus')).to be_truthy
    end

    it 'with invalid password' do
      user = build :user , password: '1Telindus'
      expect(user).to be_valid
      expect(user.authenticate('in-valid')).to be_falsey
    end
  end

  describe 'Email confirmation token' do
    after { described_class.delete_all }

    it 'automatic set the token when user is created' do
      user = create :user , password: '1Telindus'
      expect(user.email_confirm_token).not_to be_nil      
    end

    it 'when method email_confirmation_ok is invoked' do
      user = create :user , password: '1Telindus'

      ##before method
      expect(user.is_email_verified).to be_falsey
      expect(user.email_confirm_token).not_to be_nil

      user.email_confirmation_ok
      expect(user.is_email_verified).to be_truthy
      expect(user.email_confirm_token).to be_nil
    end
  end

  describe 'enumeration' do
    after { described_class.delete_all }

    it { should enumerize(:role) }
    it { should enumerize(:role).in(:user, :admin).with_default(:user) }

    it 'should set the role enum as default to :user' do
      user = create :user , password: '1Telindus'
      expect(user.role.user?).to be_truthy
      expect(user.role.admin?).to be_falsey
    end

    it 'should set the role enum to :admin' do
      user = create :user , password: '1Telindus'
      expect(user.role.user?).to be_truthy
      expect(user.role.admin?).to be_falsey

      user.role = :admin
      expect(user.role.admin?).to be_truthy
    end

  end
end
