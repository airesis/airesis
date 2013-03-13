class AddGroupsFolder < ActiveRecord::Migration
  def up
    Dir.mkdir("#{Rails.root}/private") unless File.exists?("#{Rails.root}/private")
    Dir.mkdir("#{Rails.root}/private/elfinder") unless File.exists?("#{Rails.root}/private/elfinder")
    Group.all.each do |group|
      Dir.mkdir("#{Rails.root}/private/elfinder/#{group.id}") unless File.exists?("#{Rails.root}/private/elfinder/#{group.id}")
    end
  end

  def down
  end
end
