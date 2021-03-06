class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :books
  has_many :booktemplates
  has_many :imagegalleries
  has_many :images, through: :imagegallery

  def label_method
    "#{first_name} #{last_name}"
  end
end
