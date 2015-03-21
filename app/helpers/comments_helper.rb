module CommentsHelper

  def unread_count(count)
    if count > 0
      content_tag "span", style: 'color: #8075c4' do
        "(#{count} new)"
      end
    end
  end

end
