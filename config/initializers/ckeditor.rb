Ckeditor.setup do |config|
  require 'ckeditor/orm/active_record'

  config.image_file_types = %w[jpg jpeg png gif tiff]

  config.attachment_file_types = %w[doc docx xls odt ods pdf rar zip tar swf]

  config.authorize_with :cancan

  config.cdn_url = '//cdn.ckeditor.com/4.14.0/standard-all/ckeditor.js'
end
