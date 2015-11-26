namespace :assets do
  # We make use of rake's behaviour and chain this after rails' assets:precompile.
  desc 'Gzip assets after rails has finished precompilation'
  task :precompile do
    require 'zlib'
    Dir['public/assets/**/*.{js,css}'].each do |path|
      gz_path = "#{path}.gz"
      next if File.exist?(gz_path)

      Zlib::GzipWriter.open(gz_path) do |gz|
        gz.mtime = File.mtime(path)
        gz.orig_name = path
        gz.write(IO.binread(path))
      end
    end
  end
end
