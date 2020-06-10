require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#absolute_url_for' do

    it 'returns a full url to confirm email path' do
      expect( helper.absolute_url_for(action: 'confirm_email', controller: 'auth', token: 'aaaaa') ).to eq('http://localhost:3000/auth/confirm_email/aaaaa')
    end

  end
end