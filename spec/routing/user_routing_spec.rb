require 'rails_helper'

describe 'Routes' do
  describe 'users controller routes' do
    it 'to index' do
      expect(:get => '/users').to route_to('users#index')
    end

    it 'to show' do
      expect(:get => '/users/1').to route_to('users#show', id: '1')
      expect(get("/users/1")).
        to route_to(:controller => "users", :action => "show", :id => '1')
    end    
  end
  
  describe 'auth controller routes' do
    it 'to signup' do
      expect(:post => '/auth/signup').to route_to('auth#signup')
      expect(post("/auth/signup")).
        to route_to(:controller => "auth", :action => "signup")    
    end

    it 'to confirm_email' do
      expect(:get => '/auth/confirm_email/token').to route_to('auth#confirm_email', token: 'token')
      expect(get("/auth/confirm_email/token")).
        to route_to(:controller => "auth", :action => "confirm_email", :token => 'token')
    end

    it 'to login' do
      expect(:post => '/auth/login').to route_to('auth#login')
      expect(post("/auth/login")).
        to route_to(:controller => "auth", :action => "login")    
    end
  end


  
end