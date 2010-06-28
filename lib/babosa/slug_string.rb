# encoding: utf-8

module Babosa

  # This class provides some string-manipulation methods specific to slugs.
  #
  # Note that this class includes many "bang methods" such as {#clean!} and
  # {#normalize!} that perform actions on the string in-place. Each of these
  # methods has a corresponding "bangless" method (i.e., +SlugString#clean!+
  # and +SlugString#clean+) which does not appear in the documentation because
  # it is generated dynamically.
  #
  # All of the bang methods return an instance of String, while the bangless
  # versions return an instance of Babosa::SlugString, so that calls to methods
  # specific to this class can be chained:
  #
  #   string = SlugString.new("hello world")
  #   string.with_dashes! # => "hello-world"
  #   string.with_dashes  # => <Babosa::SlugString:0x000001013e1590 @wrapped_string="hello-world">
  #
  # @see http://www.utf8-chartable.de/unicode-utf8-table.pl?utf8=dec Unicode character table
  class SlugString

    attr_reader :wrapped_string
    alias to_s wrapped_string

    @@utf8_proxy = if RUBY_ENGINE == "java"
      UTF8::JavaProxy
    elsif defined? Unicode
      UTF8::UnicodeProxy
    elsif defined? ActiveSupport
      UTF8::ActiveSupportProxy
    else
      UTF8::DumbProxy
    end

    def self.utf8_proxy
      @@utf8_proxy
    end

    def self.utf8_proxy=(klass)
      @@utf8_proxy = klass
    end

    def method_missing(symbol, *args, &block)
      @wrapped_string.__send__(symbol, *args, &block)
    end

    # @param string [String] The string to use as the basis of the SlugString.
    def initialize(string)
      @wrapped_string = string
      tidy_bytes!
      normalize_utf8!
    end

    # Approximate an ASCII string. This works only for Western strings using
    # characters that are Roman-alphabet characters + diacritics. Non-letter
    # characters are left unmodified.
    #
    #   string = SlugString.new "Łódź, Poland"
    #   string.approximate_ascii                 # => "Lodz, Poland"
    #   string = SlugString.new "日本"
    #   string.approximate_ascii                 # => "日本"
    #
    # You can pass any key(s) from {APPROXIMATIONS} as arguments. This allows
    # for contextual approximations. By default; +:spanish+ and +:german+ are
    # provided:
    #
    #   string = SlugString.new "Jürgen Müller"
    #   string.approximate_ascii                 # => "Jurgen Muller"
    #   string.approximate_ascii :german         # => "Juergen Mueller"
    #   string = SlugString.new "¡Feliz año!"
    #   string.approximate_ascii                 # => "¡Feliz ano!"
    #   string.approximate_ascii :spanish        # => "¡Feliz anio!"
    #
    # You can modify the built-in approximations, or add your own:
    #
    #   # Make Spanish use "nh" rather than "nn"
    #   Babosa::Characters.add_approximations(:spanish, "ñ" => "nh")
    #
    # Notice that this method does not simply convert to ASCII; if you want
    # to remove non-ASCII characters such as "¡" and "¿", use {#to_ascii!}:
    #
    #   string.approximate_ascii!(:spanish)       # => "¡Feliz anio!"
    #   string.to_ascii!                          # => "Feliz anio!"
    # @param *args <Symbol>
    # @return String
    def approximate_ascii!(overrides = {})
      overrides = Characters.approximations[overrides] if overrides.kind_of? Symbol
      @wrapped_string = unpack("U*").map { |char| approx_char(char, overrides) }.flatten.pack("U*")
    end

    # Removes leading and trailing spaces or dashses, and replaces multiple
    # whitespace characters with a single space.
    # @return String
    def clean!
      @wrapped_string = @wrapped_string.gsub(/\A\-|\-\z/, "").gsub(/\s+/u, " ").strip
    end

    # Remove any non-word characters.
    # @return String
    def word_chars!
      @wrapped_string = (unpack("U*") - Characters.strippable).pack("U*")
    end

    # Normalize the string for use as a slug. Note that in this context,
    # +normalize+ means, strip, remove non-letters/numbers, downcasing,
    # truncating to 255 bytes and converting whitespace to dashes.
    # @return String
    def normalize!
      clean!
      word_chars!
      downcase!
      truncate_bytes!(255)
      with_dashes!
    end

    # Delete any non-ascii characters.
    # @return String
    def to_ascii!
      @wrapped_string = @wrapped_string.gsub(/[^\x00-\x7f]/u, '')
    end

    # Truncate the string to +max+ length.
    # @return String
    def truncate!(max)
      @wrapped_string = unpack("U*")[0...max].pack("U*")
    end

    def truncate_bytes!(len)
      return @wrapped_string if @wrapped_string.bytesize < len
      curr = 0
      @wrapped_string = unpack("U*").map do |char|
        break if curr > len
        curr += [char].pack("U").bytesize
        char if curr <= len
      end.to_a.compact.pack("U*")
    end

    # Replaces whitespace with dashes ("-").
    # @return String
    def with_dashes!
      @wrapped_string = @wrapped_string.gsub(/\s/u, "-").squeeze("-")
    end

    def upcase!
      @wrapped_string = @@utf8_proxy.upcase(@wrapped_string)
    end

    def downcase!
      @wrapped_string = @@utf8_proxy.downcase(@wrapped_string)
    end

    def normalize_utf8!
      @wrapped_string = @@utf8_proxy.normalize_utf8(@wrapped_string)
    end

    def tidy_bytes!
      @wrapped_string = @@utf8_proxy.tidy_bytes(@wrapped_string)
    end

    %w[approximate_ascii clean downcase word_chars normalize normalize_utf8
      tidy_bytes to_ascii truncate truncate_bytes upcase with_dashes].each do |method|
      class_eval(<<-EOM)
        def #{method}(*args)
          send_to_new_instance(:#{method}!, *args)
        end
      EOM
    end

    private

    # Look up the character's approximation in the configured maps.
    def approx_char(char, overrides = {})
      overrides[char] or Characters.approximations[:latin][char] or char
    end

    # Used as the basis of the bangless methods.
    def send_to_new_instance(*args)
      string = SlugString.new self
      string.send(*args)
      string
    end

  end
end
