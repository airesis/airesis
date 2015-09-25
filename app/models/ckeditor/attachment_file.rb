module Ckeditor
  class AttachmentFile < Ckeditor::Asset
    has_attached_file :data, path: (Paperclip::Attachment.default_options[:storage] == :s3) ?
                             'ckeditor_assets/attachments/:id/:filename' : ':rails_root/public:url'

    validates_attachment_presence :data
    validates_attachment_size :data, less_than: 100.megabytes
    do_not_validate_attachment_file_type :data

    def url_thumb
      @url_thumb ||= Ckeditor::Utils.filethumb(filename)
    end
  end
end
