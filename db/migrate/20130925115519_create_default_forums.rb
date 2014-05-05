class CreateDefaultForums < ActiveRecord::Migration
  def up

    remove_index :frm_categories, :slug
    add_index :frm_categories, :slug
    add_index :frm_categories, [:group_id,:slug], unique: true

    Group.all.each do |group|
      @private = group.categories.create(name: 'Sezione privata', visible_outside: false)
      @f = @private.forums.build(name: 'Forum privato', description: 'Forum riservato a coloro che appartengono al gruppo', visible_outside: false)
      @f.group = group
      @f.save!

      @public = group.categories.create(name: 'Sezione pubblica')
      @f = @public.forums.create(name: 'Forum pubblico', description: 'Forum aperto a tutti i partecipanti di Airesis. Anche a coloro che non appartengono al gruppo')
      @f.group = group
      @f.save!
    end
  end

  def down
    remove_index :frm_categories, :slug
    remove_index :frm_categories, [:group_id,:slug]
    add_index :frm_categories, :slug, unique: true


    Group.all.each do |group|
      group.forums.destroy_all
      group.categories.destroy_all
    end
  end
end
