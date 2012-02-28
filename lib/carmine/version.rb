class Carmine
  module Version
    Major, Minor, Patch =
      File.read(File.expand_path('../../../VERSION', __FILE__)).split('.')
  end
  
  class << self
    # Public: The version of the client.
    #
    # Returns a String of the dot joined version parts.
    def version
      [Version::Major, Version::Minor, Version::Patch].join('.')
    end
  end
end
