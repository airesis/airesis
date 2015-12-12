namespace :airesis do
  desc 'Extract some statistics'
  task stats: :environment do
    ret = {}
    ret[:total] = 0
    ret[:classifications] = {}
    ret[:not_calculated] = 0
    ret[:proposals] = Proposal.voted.
      joins(:solutions).
      group('proposals.id').
      having('count(solutions.*) > 1').count.map do |proposal_id, count|
      proposal = Proposal.find(proposal_id)
      solver = SchulzeSolver.new(proposal)
      solution = solver.calculate
      ret[:total] += 1

      if solution[:calculated]
        num_classifications = solution[:classifications].count.to_s
        ret[:classifications][num_classifications] ||= 0
        ret[:classifications][num_classifications] += 1
      else
        ret[:not_calculated] += 1
      end
      { proposal_id: proposal_id,
        solutions_count: count,
        votes_count: proposal.user_votes_count,
        solutions: proposal.solutions.map(&:id),
        preferences: proposal.schulze_votes.map { |vote| { count: vote.count, data: vote.preferences } },
        solution: solution }
    end
    File.open('stat.json', 'w') { |f| f.puts JSON.pretty_generate(ret) }
  end
end
