require "paperclip"
    
Paperclip.options[:command_path] = 'C:\Program Files\ImageMagick-6.7.2-Q16'
Paperclip.options[:swallow_stderr] = false

#todo remove in 4.1
require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end
