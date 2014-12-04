module BlogPostsHelper

  def blog_post_label(blog_post)
    if blog_post.draft?
      content_tag :div, class: 'label round warning', data: {qtip: ''}, title: t('draft_tooltip') do
        t('pages.blog_posts.show.draft')
      end
    elsif blog_post.reserved?
      content_tag :div, class: 'label round', data: {qtip: ''}, title: t('reserved_tooltip') do
        t('pages.blog_posts.show.reserved')
      end
    end
  end
end
