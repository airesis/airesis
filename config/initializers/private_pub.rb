# FIXME: patch to allow reading configuration options from environment variables
module PrivatePub
  class << self
    # Loads the  configuration from a given YAML file and environment (such as production)
    def load_config(filename, environment)
      yaml = YAML.safe_load(ERB.new(File.read(filename)).result)[environment.to_s]
      raise ArgumentError, "The #{environment} environment does not exist in #{filename}" if yaml.nil?

      yaml.each { |k, v| config[k.to_sym] = v }
      config[:signature_expiration] = config[:signature_expiration].to_i if config[:signature_expiration] && !config[:signature_expiration].is_a?(Integer)
    end
  end
end
