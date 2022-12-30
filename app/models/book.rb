class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  
  #今日の投稿数
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  #前日の投稿数
	scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
	#今週の投稿数
	scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) } 
	#前週の投稿数
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) } 
	
  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end
end
