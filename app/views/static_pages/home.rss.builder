xml.instruct! :xml, version: "1.0" 
xml.rss version: "2.0" do
  xml.channel do
    xml.title current_user.name
    xml.description "Status feed"
    xml.link user_url(current_user)

    @feed_items.each do |feed_item|
      xml.item do
        xml.title "#{feed_item.content[0..10]}..."
        xml.description feed_item.content
        xml.pubDate feed_item.created_at.to_s(:rfc822)
        xml.author feed_item.user.username
      end
    end
  end
end