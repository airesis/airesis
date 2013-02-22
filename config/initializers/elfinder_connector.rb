require 'base64'

ElFinder::Connector.class_eval do
    def _upload
      if perms_for(@current)[:write] == false
        @response[:error] = 'Access Denied'
        return
      end
      select = []
      @params[:upload].to_a.each do |file|
        if file.respond_to?(:tempfile)
          the_file = file.tempfile
        else
          the_file = file
        end
        a = File.size(the_file.path)
        b = upload_max_size_in_bytes
        if  a > b
          @response[:error] ||= "Alcuni file non sono stati caricati. Superano la dimensione massima consentita."
          @response[:errorData][@options[:original_filename_method].call(file)] = 'File exceeds the maximum allowed filesize'
        else
          dst = @current + @options[:original_filename_method].call(file)
          the_file.close
          src = the_file.path
          FileUtils.mv(src, dst.fullpath)
          FileUtils.chmod @options[:upload_file_mode], dst
          select << to_hash(dst)
          @group = Group.find(@params[:group_id])
          @group.actual_storage_size += (a.to_f / 1024).to_i
          @group.save!
        end
      end
      @response[:select] = select unless select.empty?
      _open(@current)
    end # of upload


    def remove_target(target)
      @group ||= Group.find(@params[:group_id])
      if target.directory?
        target.children.each do |child|
          remove_target(child)
        end
      end
      if perms_for(target)[:rm] == false
        @response[:error] ||= 'Some files/directories were unable to be removed'
        @response[:errorData][target.basename.to_s] = "Access Denied"
      else
        begin
          @group.actual_storage_size -= (File.size(target.path).to_f / 1024).to_i
          target.unlink
          if @options[:thumbs] && (thumbnail = thumbnail_for(target)).file?
            @group.actual_storage_size -= (File.size(thumbnail.path).to_f / 1024).to_i
            thumbnail.unlink
          end
          @group.save!
        rescue
          @response[:error] ||= 'Some files/directories were unable to be removed'
          @response[:errorData][target.basename.to_s] = "Remove failed"
        end
      end
    end
end # of module ElFinder
