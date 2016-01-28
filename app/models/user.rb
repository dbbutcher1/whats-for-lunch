class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  has_one :address

  has_many :ratings
  has_many :restaurants, through: :ratings

  accepts_nested_attributes_for :address

  def role?(role)
    if self.role.nil?
      false
    else
      self.role.include? role.to_s
    end
  end
end
