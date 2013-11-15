atom_feed do |feed|
  feed.title @blog.title
  feed.updated @blog_posts.maximum('blog_posts.updated_at')
  @blog_posts.each do |post|
    feed.entry post, url: blog_blog_post_url(@blog,post) do |entry|
      entry.title post.title
      entry.content post.body

      entry.author do |author|
        author.name post.user.fullname
      end
    end
  end
end