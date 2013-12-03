class NewQuora < ActiveRecord::Migration
  def up
    File.open("log/quorum_migration.log", 'w') do |f|
      f.puts('migrating to new quorums')
      add_column :quorums, :vote_minutes, :integer
      add_column :quorums, :vote_percentage, :integer
      add_column :quorums, :vote_valutations, :integer
      add_column :quorums, :vote_good_score, :integer
      add_column :quorums, :vote_start_at, :timestamp
      add_column :quorums, :vote_ends_at, :timestamp
      add_column :quorums, :t_percentage, :string, limit: 1
      add_column :quorums, :t_minutes, :string, limit: 1
      add_column :quorums, :t_good_score, :string, limit: 1
      add_column :quorums, :t_vote_percentage, :string, limit: 1
      add_column :quorums, :t_vote_minutes, :string, limit: 1
      add_column :quorums, :t_vote_good_score, :string, limit: 1
      add_column :quorums, :type, :string
      add_column :quorums, :removed, :boolean, default: false
      add_column :quorums, :old_bad_score, :integer
      add_column :quorums, :old_condition, :string, limit: 5

      Quorum.reset_column_information
      f.puts 'resetting columns'
      assigned = Quorum.assigned
      f.puts "#{assigned.count} assigned quora become Old"
      assigned.update_all({:type => 'OldQuorum'})
      unassigned = Quorum.unassigned.where('minutes is null')
      f.puts "#{unassigned.count} unassigned invalid quora are removed"
      unassigned.update_all({:removed => true})
      f.puts "Updating #{Quorum.unassigned.count} unassigned valid quora"


      GroupQuorum.find(172).destroy rescue nil #there's a wrong quorum, fix if you find it

      Quorum.unassigned.where(:removed => false).each do |quorum|
        quorum.old_condition = quorum.condition
        quorum.condition = nil
        quorum.old_bad_score = quorum.bad_score
        quorum.bad_score = quorum.good_score
        quorum.vote_percentage = 0
        quorum.vote_good_score = 50
        quorum.t_percentage = 's'
        quorum.t_minutes = 's'
        quorum.t_good_score = 's'
        quorum.t_vote_percentage = 's'
        quorum.t_vote_minutes = 'f'
        quorum.t_vote_good_score = 's'
        quorum.type = 'BestQuorum'
        quorum.save!
      end
    end
  end

  def down
    Quorum.unassigned.where(:removed => false).each do |quorum|
      quorum.bad_score = quorum.old_bad_score
      quorum.condition = quorum.old_condition
      quorum.save!
    end
    remove_column :quorums, :old_condition
    remove_column :quorums, :old_bad_score
    remove_column :quorums, :removed
    remove_column :quorums, :vote_minutes
    remove_column :quorums, :vote_percentage
    remove_column :quorums, :vote_valutations
    remove_column :quorums, :vote_good_score
    remove_column :quorums, :vote_start_at
    remove_column :quorums, :vote_ends_at
    remove_column :quorums, :t_percentage
    remove_column :quorums, :t_minutes
    remove_column :quorums, :t_good_score
    remove_column :quorums, :t_vote_percentage
    remove_column :quorums, :t_vote_minutes
    remove_column :quorums, :t_vote_good_score
    remove_column :quorums, :type
  end
end
