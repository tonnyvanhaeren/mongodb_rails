require 'rails_helper'

describe 'Users routes' do
  it 'should route to users index' do
    expect(:get => '/users').to route_to('users#index')
  end

  it 'should route to users create' do
    expect(:post => '/users').to route_to('users#create')
  end

  it 'should route to users show' do
    expect(:get => '/users/1').to route_to('users#show', id: '1')
    expect(get("/users/1")).
      to route_to(:controller => "users", :action => "show", :id => '1')
  end

  it 'should toute to users create' do
    expect(:post => '/users').to route_to('users#create')
    expect(post("/users")).
      to route_to(:controller => "users", :action => "create")
  end
  
end