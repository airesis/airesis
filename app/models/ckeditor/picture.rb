module Ckeditor
  class Picture < Ckeditor::Asset
    has_attached_file :data,
                      path: (Paperclip::Attachment.default_options[:storage] == :s3) ?
                        'ckeditor_assets/pictures/:id/:style_:basename.:extension' : ':rails_root/public:url',
                      styles: { content: '800>', thumb: '118x100#' }

    validates_attachment_presence :data
    validates_attachment_size :data, less_than: 2.megabytes
    validates_attachment_content_type :data, content_type: /\Aimage/

    def url_content
      url(:content)
    end
  end
end
