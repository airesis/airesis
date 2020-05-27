atom_feed do |feed|
  feed.title @group.name
  feed.updated @group_posts.maximum('blog_posts.updated_at')
  @group_posts.each do |post_publishing|
    feed.entry post_publishing.blog_post, url: group_blog_post_url(@group, post_publishing.blog_post) do |entry|
      entry.title post_publishing.blog_post.title
      entry.content post_publishing.blog_post.body

      entry.author do |author|
        author.name post_publishing.blog_post.user.fullname
      end
    end
  end
end
