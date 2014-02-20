class FixForEditors < ActiveRecord::Migration
  def up
    Paragraph.update_all("content = '<p></p>'","content = ''")
  end

  def down
    Paragraph.update_all("content = ''","content = '<p></p>'")
  end
end
