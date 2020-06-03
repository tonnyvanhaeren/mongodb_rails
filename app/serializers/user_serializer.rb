class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :firstName, :lastName, :fullName, :is_email_verified, :is_accepted

  def fullName
    fullName = object.firstName + ' - ' + object.lastName
    return fullName
 end
end
