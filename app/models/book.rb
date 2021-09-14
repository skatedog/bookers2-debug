class Book < ApplicationRecord
	is_impressionable
	belongs_to :user
	has_many :favorites, dependent: :destroy
	has_many :book_comments, dependent: :destroy

	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}

	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end

	scope :posted_today, -> { where(created_at: Time.current.all_day) }
	scope :posted_yesterday, -> { where(created_at: 1.day.ago.all_day) }
	scope :posted_this_week, -> { where(created_at: 1.week.ago.beginning_of_day + 1.day .. Time.current.end_of_day) }
	scope :posted_last_week, -> { where(created_at: 2.week.ago.beginning_of_day + 1.day .. 1.week.ago.end_of_day) }

end
