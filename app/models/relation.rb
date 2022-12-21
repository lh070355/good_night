class Relation < ApplicationRecord
  # followers cannot follow themselves
  validates :followee_id, presence: true, comparison: { other_than: :follower_id }
  # each record is unique in their follower_id and followee_id pair
  validates :follower_id, presence: true, uniqueness: { scope: :followee_id }

  belongs_to :follower, class_name: 'User', inverse_of: :followee_relations
  belongs_to :followee, class_name: 'User', inverse_of: :follower_relations
end
