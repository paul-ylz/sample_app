xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0' do
  xml.channel do
    xml.title @user.name
    xml.description 'Recent posts'
    xml.link user_url(@user)

    @microposts.each do |micropost|
      xml.item do
        xml.title "#{micropost.content[0..10]}..."
        xml.description micropost.content
        xml.pubDate micropost.created_at.to_s(:rfc822)
        xml.author @user.username
      end
    end
  end
end
