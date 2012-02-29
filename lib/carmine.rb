require 'httparty'

class Carmine
  include HTTParty

  # Public: The base error for the library.
  #
  # Raised when there is something wrong with the colorization request. 
  class Error < StandardError
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def to_s
      return @response.body unless /\(.*?\)/ =~ @response.body
      $~.gsub /[()]/, ""
    end
  end

  class << self
    # Public: Delegates the calls to '#colorize', '#pygmentize' and #defaults.
    #
    # Examples
    #
    #   Carmine.colorize "puts 'Hello World!'", :lexer => :ruby
    #   Carmine.pygmentize "puts 'Hello World!'", :lexer => :ruby
    def method_missing(name, *args, &block)
      if instance.respond_to? name
        instance.send name, *args, &block
      else
        super
      end
    end

    private

    def instance
      @instance ||= new
    end
  end

  base_uri 'pygmentize.me'

  # Public: Gets/Sets the client default options.
  attr_accessor :defaults

  # Public: Initialize the carmine object.
  #
  # options - The default options to use when colorizing.
  #           :formatter (default: :html)
  #           :lexer     (default: :plain)
  def initialize(options = {})
    @defaults = {
      :formatter => :html,
      :lexer     => :plain
    }.merge options
  end

  # Public: Colorizes the given code using the specified :formatter and :lexer.
  #
  # code    - The code to colorize (default: nil).
  # options - The option passed to the pygmentize.me api, the optinal options
  #           take their defaults from the hash passed in the constructor.
  #           :code      - Can be specified here (optional).
  #           :formatter - The name of the formatter to use (optional).
  #           :lexer     - The name of the lexer to use (optiona).
  #
  # Examples 
  #
  #   colorize "puts 'Hello World!'", :lexer => :ruby, :formatter => :text
  #   # => "puts 'Hello World!'"
  #
  #   colorize :code => "puts 'Hello World!'", :lexer => :ruby, :formatter => :text
  #   # => "puts 'Hello World!'"
  #
  # Returns the colorized code.
  # Yields the colorized code if there is a block given.
  def colorize(code = nil, options = {})
    params        = @defaults.merge options
    params[:code] = code.respond_to?(:read) ? code.read : code unless code.nil?

    raise ArgumentError, "Argument or option :code missing" if params[:code].nil?

    response = post "/api/formatter/#{options[:formatter]}", :query => params

    raise Error, response unless response.success?

    if block_given?
      yield response.body
    else
      response.body
    end
  end

  alias :pygmentize :colorize

  private

  def post(path, options = {})
    self.class.post path, @defaults.merge(options)
  end
end

require 'carmine/version'
