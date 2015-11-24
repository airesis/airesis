class LowcaseAllEmails < ActiveRecord::Migration
  def change
    execute "UPDATE users set email = lower(email)"
  end
end
