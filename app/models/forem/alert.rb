module Forem
  class Alert
    include Mongoid::Document
    include Mongoid::Timestamps
    include ActionView::Helpers::DateHelper

    field :read, :type => Boolean, :default => false, :index => true

    field :created_at, :type => DateTime
    field :updated_at, :type => DateTime
    field :read_at, :type => DateTime

    # Forem::Topic
    field :forem_topic_replier
    field :forem_topic_count, :default => 0
    belongs_to :forem_topic_post, :class_name => "Forem::Post"

    # Relations
    belongs_to :subscription, :class_name => "Forem::Subscription", :index => true
    belongs_to :user, :index => true

    def link
      str = ""
      case self.subscription.subscribable_type
      when "Forem::Topic"
        str += "/forums/posts/" + self.forem_topic_post.id.to_s
      else
        str
      end
      str
    end

    def text
      str = ""
      case self.subscription.subscribable_type
      when "Forem::Topic"
        str += self.forem_topic_replier
        if self.forem_topic_count > 0
          str += " and " + self.forem_topic_count.to_s + " other" + (self.forem_topic_count > 1 ? "s" : "")
        end
        str += " replied to " + self.subscription.subscribable.subject
      else
        str
      end
      str += " " + time_ago_in_words(self.updated_at) + " ago"
    end
  end

end