class Micropost < ActiveRecord::Base
    belongs_to :user
    default_scope -> { order('created_at DESC') }
    scope :including_replies, -> (user) { from_users_including_replies_followed_by(user) } 
    validates :user_id, presence: true
    validates :content, presence: true, length: { maximum: 140 }

    before_save do
        m = /^@([a-zA-Z0-9_]+{1,15})\ /.match(content)
        if m != nil
            username_mentioned = m[1]
            user_mentioned = User.find_by(username: username_mentioned) 
            self.in_reply_to = user_mentioned.id if user_mentioned != nil
        end
    end

    def self.from_users_followed_by(user)
        where("user_id IN (SELECT followed_id from relationships WHERE follower_id = :user_id) 
              OR user_id = :user_id",
              user_id: user.id) 
    end

    private

    def self.from_users_including_replies_followed_by(user)
        where("user_id IN (SELECT followed_id from relationships WHERE follower_id = :user_id) 
              OR user_id = :user_id
              OR in_reply_to = :user_id", 
              user_id: user.id) 
    end
end
