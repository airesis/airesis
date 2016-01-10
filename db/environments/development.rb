files = Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort

airesis_seed = files.shift
load airesis_seed

Parallel.each(files, :in_processes => 4) { |seed|
  startTime = Time.now
  load seed
  endTime = Time.now
  delta = endTime - startTime
  puts 'Completed ' + File.basename(seed) + ' in ' + delta.abs.to_s + 's'
}