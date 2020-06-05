class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :firstName, :lastName, :fullName, :is_email_verified, :is_accepted, :updated_at, :created_at

  def fullName
    fullName = object.firstName + ' - ' + object.lastName
    return fullName
  end
end
