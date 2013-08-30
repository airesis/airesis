class FixOldAlert < ActiveRecord::Migration
  def up
    change_column :notifications, :url, :string, limit: 400
    @host = "http://www.#{Airesis::Application.default_url_options[:host]}"
    Notification.update_all("url = '#{@host}' || url", "url not like 'http://%'")
  end

  def down
    change_column :notifications, :url, :string, limit: 255
    @host = "http://www.#{Airesis::Application.default_url_options[:host]}"
    Notification.update_all("url = replace(url,'#{@host}','')")
  end
end
