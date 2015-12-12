class SchulzeSolver
  LIMIT = 10

  def initialize(proposal)
    @proposal = proposal
    @solutions_sorted_ids = @proposal.solutions.sort { |a, b| a.id <=> b.id }.map(&:id)
  end

  def calculate
    vs = run_schulze
    extract_json_results(vs)
  end

  def extract_json_results(vs)
    ret = json_data(vs)
    ret[:classifications] = generate_classifications(vs)
    ret[:calculated] = true
    ret
  rescue TooManyClassificationsException
    ret
  end

  def generate_classifications(vs)
    classifications = vs.classifications(LIMIT)

    classifications.map do |classification|
      classification.map { |el| @solutions_sorted_ids[el] }
    end
  end

  def json_data(vs)
    ret = { elements: @solutions_sorted_ids, calculated: false, limit: LIMIT }
    ret[:winners] = extract_winners(vs)
    ret[:beat_couples] = extract_beat_couples(vs)
    ret[:ranks] = extract_ranks(vs)
    ret
  end

  def extract_ranks(vs)
    ranks = vs.ranks
    @solutions_sorted_ids.each_with_index.map do |sol_id, idx|
      [sol_id, ranks[idx]]
    end
  end

  def extract_beat_couples(vs)
    beat_couples = vs.beat_couples
    beat_couples.map do |couple|
      [@solutions_sorted_ids[couple[0]], @solutions_sorted_ids[couple[1]]]
    end
  end

  def extract_winners(vs)
    winners_idx = vs.winners_array
    winners = @solutions_sorted_ids.each_with_index.select do |_sol, idx|
      winners_idx[idx] == 1
    end
    winners.map { |c| c[0] }
  end

  private

  def run_schulze
    votesstring = generate_vote_string(@proposal.schulze_votes)
    num_solutions = @proposal.solutions.count
    SchulzeBasic.do votesstring, num_solutions
  end

  def generate_vote_string(schulze_votes)
    votesstring = '' # this is the string to pass to schulze library to calculate the score
    schulze_votes.each do |vote|
      # each row is composed by the vote string and, if more then one, the number of votes of that kind
      vote.count > 1 ? votesstring += "#{vote.count}=#{vote.preferences}\n" : votesstring += "#{vote.preferences}\n"
    end
    votesstring
  end
end
