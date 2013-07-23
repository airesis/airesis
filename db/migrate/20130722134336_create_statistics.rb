class CreateStatistics < ActiveRecord::Migration
  def up
    create_table :stat_num_proposals do |t|
      t.date :date
      t.integer :year
      t.integer :month
      t.integer :day
      t.integer :value
    end

    @array = (Time.parse("2012-02-09 00:00:00 UTC").utc.to_i..Time.now.utc.to_i).step(24.hours)
    @array.each_with_index do |step, i|
      start = Time.at(step).utc
      fin = Time.at(@array[i-1]).utc
      #puts "start: #{start}"
      #puts "end: #{fin}"
      #puts Proposal.all(:conditions => ["created_at < ? and created_at >= ?", start, fin]).explain
      num = Proposal.count(:conditions => ["created_at < ? and created_at >= ?", start, fin])
      time = Time.at(@array[i-1])
      StatNumProposal.create(date: time, value: num, year: time.year, month: time.month, day: time.day)
    end
  end

  def down
    drop_table :stat_num_proposals
  end

end
