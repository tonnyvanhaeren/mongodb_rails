require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validation' do

    it 'should test that the factory is valid' do
      user = build :user, password: '1Telindus'
      expect(user).to be_valid
    end

    it 'should validate presence of password' do
      user = build :user, password: nil
      expect(user).not_to be_valid
      expect(user.errors.messages[:password]).to include("can't be blank")
    end

    it 'should validate presence of attributes firstName, LastName' do
      user = build :user, password: '1Telindus', firstName: nil, lastName: nil
      expect(user).not_to be_valid
      expect(user.errors.messages[:firstName]).to include("can't be blank", "is too short (minimum is 2 characters)")
      expect(user.errors.messages[:lastName]).to include("can't be blank", "is too short (minimum is 2 characters)")
    end

    it 'should validate min length of attributes firstName, LastName' do
      user = build :user, password: '1Telindus', firstName: 'a', lastName: 'a'
      expect(user).not_to be_valid
      expect(user.errors.messages[:firstName]).to include("is too short (minimum is 2 characters)")
      expect(user.errors.messages[:lastName]).to include("is too short (minimum is 2 characters)")
    end

    it 'should validate max length of attributes firstName, LastName' do
      user = build :user, password: '1Telindus',
        firstName: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
        lastName: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
      expect(user).not_to be_valid
      expect(user.errors.messages[:firstName]).to include("is too long (maximum is 50 characters)")
      expect(user.errors.messages[:lastName]).to include("is too long (maximum is 50 characters)")
    end

    it 'should validate the precense of attribute email' do
      user = build :user, password: '1Telindus', email: nil
      expect(user).not_to be_valid
      expect(user.errors.messages[:email]).to include("can't be blank")
    end

    it 'should validate the format of invalid attribute email' do
      user = build :user, password: '1Telindus', email: 'opa@opa'
      expect(user).not_to be_valid
      expect(user.errors.messages[:email]).to include("Invalid email format")
    end

    it 'should validate the format of valid attribute email' do
      user = build :user, password: '1Telindus', email: 'opa@opa.be'
      expect(user).to be_valid
      ### expect(user.errors.messages[:email]).to include("Invalid email format")
    end    

    it 'should validate the uniqueness attribute email' do
      user = create :user, password: '1Telindus', email: 'opa@opa.be'
      invalid_user = build :user, password: '1Telindus', email: 'opa@opa.be'
      expect(user).to be_valid
      expect(invalid_user).not_to be_valid
      expect(invalid_user.errors.messages[:email]).to include("Email is already in use")
      ## clean up database
      user.delete
    end   
  end

  describe '#authenticate' do
    it 'should check valid password' do
      user = build :user , password: '1Telindus'
      expect(user).to be_valid
      expect(user.authenticate('1Telindus')).to be_truthy
    end

    it 'should check invalid password' do
      user = build :user , password: '1Telindus'
      expect(user).to be_valid
      expect(user.authenticate('in-valid')).to be_falsey
    end

  end
end
