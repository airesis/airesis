# record the history of a blog post if edited
class BlogPostVersion < PaperTrail::Version
  self.table_name = :blog_post_versions
  self.sequence_name = :blog_post_version_id_seq
end
