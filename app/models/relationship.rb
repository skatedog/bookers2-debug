class Relationship < ApplicationRecord
  # Userクラスのfollowedに属する
  belongs_to :followed, class_name: "User"
  # Userクラスのfollowerに属する
  belongs_to :follower, class_name: "User"

end
