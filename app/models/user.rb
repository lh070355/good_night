class User < ApplicationRecord
  validates :name, presence: true

  # destroy related relation records once user data is destroyed
  has_many :followee_relations,
           foreign_key: :follower_id,
           class_name: 'Relation',
           dependent: :destroy,
           inverse_of: :follower
  has_many :followees, through: :followee_relations
  has_many :follower_relations,
           foreign_key: :followee_id,
           class_name: 'Relation',
           dependent: :destroy,
           inverse_of: :followee
  has_many :followers, through: :follower_relations
  has_many :periods
end
