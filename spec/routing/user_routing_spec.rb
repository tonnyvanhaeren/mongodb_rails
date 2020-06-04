require 'rails_helper'

describe 'Users routes' do
  it 'should route to users index' do
    expect(:get => '/users').to route_to('users#index')
  end

  it 'should route to users create' do
    expect(:post => '/users').to route_to('users#create')
  end

end