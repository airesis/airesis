class AddKeys < ActiveRecord::Migration
  def up
    add_column :event_types, :name, :string
    EventType.find(1).update_attribute(:name, 'meeting')
    EventType.find(2).update_attribute(:name, 'vote')
    EventType.find(3).update_attribute(:name, 'meeting2')
    EventType.find(4).update_attribute(:name, 'election')

    add_column :notification_types, :name, :string
    NotificationType.find(1).update_attribute(:name, 'new_contributes')
    NotificationType.find(2).update_attribute(:name, 'text_update')
    NotificationType.find(3).update_attribute(:name, 'new_public_proposals')
    NotificationType.find(4).update_attribute(:name, 'change_status')
    NotificationType.find(5).update_attribute(:name, 'new_contributes_mine')
    NotificationType.find(6).update_attribute(:name, 'change_status_mine')
    NotificationType.find(8).update_attribute(:name, 'new_posts_group_follow')
    NotificationType.find(9).update_attribute(:name, 'new_posts_group')
    NotificationType.find(10).update_attribute(:name, 'new_proposals')
    NotificationType.find(12).update_attribute(:name, 'new_partecipation_request')
    NotificationType.find(13).update_attribute(:name, 'new_public_events')
    NotificationType.find(14).update_attribute(:name, 'new_events')
    NotificationType.find(15).update_attribute(:name, 'new_posts_user_follow')
    NotificationType.find(20).update_attribute(:name, 'new_valutation_mine')
    NotificationType.find(21).update_attribute(:name, 'new_valutation')
    NotificationType.find(22).update_attribute(:name, 'available_author')
    NotificationType.find(23).update_attribute(:name, 'author_accepted')
    NotificationType.find(24).update_attribute(:name, 'new_authors')
    NotificationType.find(25).update_attribute(:name, 'unintegrated_contribute')
    NotificationType.find(26).update_attribute(:name, 'new_blog_comment')

    add_column :proposal_categories, :name, :string
    add_column :proposal_categories, :seq, :integer
    ProposalCategory.find(5).update_attributes({name: 'no_category', seq: 20})
    ProposalCategory.find(7).update_attributes({name: 'education', seq: 9})
    ProposalCategory.find(8).update_attributes({name: 'health', seq: 6})
    ProposalCategory.find(9).update_attributes({name: 'information', seq: 11})
    ProposalCategory.find(10).update_attributes({name: 'commerce', seq: 7})
    ProposalCategory.find(11).update_attributes({name: 'work', seq: 8})
    ProposalCategory.find(12).update_attributes({name: 'security', seq: 14})
    ProposalCategory.find(13).update_attributes({name: 'world', seq: 13})
    ProposalCategory.find(14).update_attributes({name: 'minorities', seq: 15})
    ProposalCategory.find(15).update_attributes({name: 'ethics', seq: 16})
    ProposalCategory.find(16).update_attributes({name: 'sexuality', seq: 17})
    ProposalCategory.find(17).update_attributes({name: 'culture', seq: 10})
    ProposalCategory.find(18).update_attributes({name: 'entertainment', seq: 18})
    ProposalCategory.find(19).update_attributes({name: 'organization', seq: 19})
    ProposalCategory.find(20).update_attributes({name: 'agricolture', seq: 1})
    ProposalCategory.find(21).update_attributes({name: 'territory', seq: 2})
    ProposalCategory.find(22).update_attributes({name: 'mobility', seq: 3})
    ProposalCategory.find(23).update_attributes({name: 'energy', seq: 4})
    ProposalCategory.find(24).update_attributes({name: 'industry', seq: 5})
    ProposalCategory.find(25).update_attributes({name: 'democracy', seq: 12})

    add_column :vote_types, :short, :string
    VoteType.find(1).update_attribute(:short,'favorable')
    VoteType.find(2).update_attribute(:short,'neutral')
    VoteType.find(3).update_attribute(:short,'dissenting')

    remove_column :vote_types, :description
    drop_table :vote_type_translations

    remove_column :event_types, :description
    drop_table :event_type_translations

    remove_column :group_actions, :description
    drop_table :group_action_translations

    remove_column :notification_categories, :description
    drop_table :notification_category_translations

    remove_column :notification_types, :email_subject
    remove_column :notification_types, :description
    drop_table :notification_type_translations

    remove_column :proposal_categories, :description
    drop_table :proposal_category_translations

  end

  def down

    add_column :proposal_categories, :description, :string
    create_table :proposal_category_translations

    add_column :notification_types, :email_subject, :string
    add_column :notification_types, :description, :string
    create_table :notification_type_translations


    add_column :notification_categories, :description, :string
    create_table :notification_category_translations

    add_column :group_actions, :description, :string
    create_table :group_action_translations

    add_column :event_types, :description, :string
    create_table :event_type_translations

    add_column :vote_types, :description, :string
    create_table :vote_type_translations
    remove_column :vote_types, :short
    remove_column :proposal_categories, :seq
    remove_column :proposal_categories, :name
    remove_column :notification_types, :name
    remove_column :event_types, :name
  end
end
