namespace :airesis do
  namespace :groups do
    task fix_images: :environment do
      Group.where.not(old_image_url: nil).find_each do |group|
        next if group.image.exists?
        begin
          group.image = URI.parse(group.old_image_url)
          group.save
        rescue
          # ignored
        end
      end
    end
  end
end
