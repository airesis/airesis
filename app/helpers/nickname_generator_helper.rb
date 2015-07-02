require 'data_handler'
require 'name_generator'

module NicknameGeneratorHelper
  @data_handler = DataHandler.new
  @data_handler.read_data_file("lib/data-ita.txt")

  def self.give_me_a_nickname
    name_generator = NameGenerator.new(@data_handler.follower_letters)
    names = name_generator.generate_names(@data_handler.start_pairs, 1)
    return names[0].strip
   end
end

