class User
  include BCrypt
  include Mongoid::Document
  include Mongoid::Timestamps

  ## //TODO
  ## field :_id, type: String, default: ->{ name }

  field :email, type: String
  field :encrypted_password, type: String
  field :firstName, type: String
  field :lastName, type: String
  field :is_email_verified, type: Mongoid::Boolean, default: false
  field :is_accepted, type: Mongoid::Boolean, default: false

  index({email: 1}, {unique: true, name: 'unique_email_index'})

  validates :email, :firstName, :lastName, :password, presence: true
  validates :firstName, length: { in: 2..50 }
  validates :lastName, length: { in: 2..50 }
    
  validates :email, uniqueness: { case_sensitive: false, message: 'Email is already in use' }
  validates :email, email_format: { message: 'Invalid email format' }    

  ## return only email verified users
  def self.email_verified
    where(is_email_verified: true)
  end

  ## return only accepted users
  def self.accepted
    where(is_accepted: true)
  end

  def password
    @password ||= Password.new(encrypted_password) if encrypted_password.present?
  end

  def password=(new_password)
    return @password = new_password if new_password.blank?
    @password = Password.create(new_password)
    self.encrypted_password = @password
  end

  def authenticate(plaintxt_pass)
    if Password.new(self.encrypted_password) == plaintxt_pass
      true
    end
 end

  private 

  def hash_password
    @password = Password.create(new_password)
    self.encrypted_password = @password
  end

end
