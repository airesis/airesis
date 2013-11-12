atom_feed do |feed|
  feed.title @group.name
  feed.updated @group_posts.maximum('blog_posts.updated_at')
  @group_posts.each do |post|
    feed.entry post, url: group_blog_post_url(@group,post) do |entry|
      entry.title post.title
      entry.content post.body

      entry.author do |author|
        author.name post.user.fullname
      end
    end
  end
end