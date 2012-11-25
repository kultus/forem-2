module Forem
  module TopicsHelper
    def link_to_latest_post(post)
      text = "#{time_ago_in_words(post.created_at, false, :vague => true)} ago"
      link_to text, root_path + "posts/" + post.id.to_s
    end

    def new_since_last_view_text(topic)
      if forem_user
        topic_view = topic.view_for(forem_user)
        forum_view = topic.forum.view_for(forem_user)

        if forum_view
          if topic_view.nil? && topic.created_at > forum_view.past_viewed_at
            content_tag :super, "New"
          end
        end
      end
    end
  end
end
