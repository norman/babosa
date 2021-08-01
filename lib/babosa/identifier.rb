# frozen_string_literal: true

module Babosa
  # This class provides some string-manipulation methods specific to slugs.
  #
  # Note that this class includes many "bang methods" such as {#clean!} and
  # {#normalize!} that perform actions on the string in-place. Each of these
  # methods has a corresponding "bangless" method (i.e., +Identifier#clean!+
  # and +Identifier#clean+) which does not appear in the documentation because
  # it is generated dynamically.
  #
  # All of the bang methods return an instance of String, while the bangless
  # versions return an instance of {Babosa::Identifier}, so that calls to methods
  # specific to this class can be chained:
  #
  #   string = Identifier.new("hello world")
  #   string.with_separators! # => "hello-world"
  #   string.with_separators  # => <Babosa::Identifier:0x000001013e1590 @wrapped_string="hello-world">
  #
  # @see http://www.utf8-chartable.de/unicode-utf8-table.pl?utf8=dec Unicode character table
  class Identifier
    Error = Class.new(StandardError)

    attr_reader :wrapped_string
    alias to_s wrapped_string

    def method_missing(symbol, *args, &block)
      @wrapped_string.__send__(symbol, *args, &block)
    end

    def respond_to_missing?(name, include_all)
      @wrapped_string.respond_to?(name, include_all)
    end

    # @param string [#to_s] The string to use as the basis of the Identifier.
    def initialize(string)
      @wrapped_string = string.to_s.dup
      tidy_bytes!
      normalize_utf8!
    end

    def ==(other)
      to_s == other.to_s
    end

    def eql?(other)
      self == other
    end

    # Approximate an ASCII string. This works only for strings using characters
    # that are Roman-alphabet characters + diacritics. Non-letter characters
    # are left unmodified.
    #
    #   string = Identifier.new "Łódź, Poland"
    #   string.transliterate                 # => "Lodz, Poland"
    #   string = Identifier.new "日本"
    #   string.transliterate                 # => "日本"
    #
    # You can pass the names of any transliterator class as arguments. This
    # allows for contextual approximations. Various languages are supported,
    # you can see which ones by looking at the source of
    # {Babosa::Transliterator::Base}.
    #
    #   string = Identifier.new "Jürgen Müller"
    #   string.transliterate                 # => "Jurgen Muller"
    #   string.transliterate :german         # => "Juergen Mueller"
    #   string = Identifier.new "¡Feliz año!"
    #   string.transliterate                 # => "¡Feliz ano!"
    #   string.transliterate :spanish        # => "¡Feliz anio!"
    #
    # The approximations are an array, which you can modify if you choose:
    #
    #   # Make Spanish use "nh" rather than "nn"
    #   Babosa::Transliterator::Spanish::APPROXIMATIONS["ñ"] = "nh"
    #
    # Notice that this method does not simply convert to ASCII; if you want
    # to remove non-ASCII characters such as "¡" and "¿", use {#to_ascii!}:
    #
    #   string.transliterate!(:spanish)       # => "¡Feliz anio!"
    #   string.to_ascii!                      # => "Feliz anio!"
    #
    # @param *args <Symbol>
    # @return String
    def transliterate!(*kinds)
      kinds.compact!
      kinds = [:latin] if kinds.empty?
      kinds.each do |kind|
        transliterator = Transliterator.get(kind).instance
        @wrapped_string = transliterator.transliterate(@wrapped_string)
      end
      to_s
    end

    # Converts dashes to spaces, removes leading and trailing spaces, and
    # replaces multiple whitespace characters with a single space.
    #
    # @return String
    def clean!
      gsub!(/[- ]+/, " ")
      strip!
      to_s
    end

    # Remove any non-word characters. For this library's purposes, this means
    # anything other than letters, numbers, spaces, underscores, dashes,
    # newlines, and linefeeds.
    #
    # @return String
    def word_chars!
      # `^\p{letter}` = Any non-Unicode letter
      # `&&` = add the following character class
      # `[^ _\n\r]` = Anything other than space, underscore, newline or linefeed
      gsub!(/[[^\p{letter}]&&[^ \d_\-\n\r]]/, "")
      to_s
    end

    # Normalize the string for use as a URL slug. Note that in this context,
    # +normalize+ means, strip, remove non-letters/numbers, downcasing,
    # truncating to 255 bytes and converting whitespace to dashes.
    #
    # @param options [Hash]
    # @return String
    def normalize!(options = {})
      options = default_normalize_options.merge(options)

      if options[:transliterate]
        option = options[:transliterate]
        if option == true
          transliterate!(*options[:transliterations])
        else
          transliterate!(*option)
        end
      end
      to_ascii! if options[:to_ascii]
      word_chars!
      clean!
      downcase!
      truncate_bytes!(options[:max_length])
      with_separators!(options[:separator])
    end

    # Normalize a string so that it can safely be used as a Ruby method name.
    #
    # @param allow_bangs [Boolean]
    # @return String
    def to_ruby_method!(allow_bangs: true)
      last_char = self[-1]
      transliterate!
      to_ascii!
      word_chars!
      strip_leading_digits!
      clean!
      @wrapped_string += last_char if allow_bangs && ["!", "?"].include?(last_char)
      raise Error, "Input generates impossible Ruby method name" if self == ""

      with_separators!("_")
    end

    # Delete any non-ascii characters.
    #
    # @return String
    def to_ascii!
      gsub!(/[^\x00-\x7f]/u, "")
      to_s
    end

    # Truncate the string to +max+ characters.
    #
    # @example
    #   "üéøá".to_identifier.truncate(3) #=> "üéø"
    #
    # @param max [Integer] The maximum number of characters.
    # @return String
    def truncate!(max)
      @wrapped_string = slice(0, max)
    end

    # Truncate the string to +max+ bytes. This can be useful for ensuring that
    # a UTF-8 string will always fit into a database column with a certain max
    # byte length. The resulting string may be less than +max+ if the string must
    # be truncated at a multibyte character boundary.
    #
    # @example
    #   "üéøá".to_identifier.truncate_bytes(3) #=> "ü"
    #
    # @param max [Integer] The maximum number of bytes.
    # @return String
    def truncate_bytes!(max)
      truncate!(max)
      chop! until bytesize <= max
    end

    # Replaces whitespace with dashes ("-").
    #
    # @param char [String] the separator character to use.
    # @return String
    def with_separators!(char = "-")
      gsub!(/\s/u, char)
      to_s
    end

    # Perform Unicode composition on the wrapped string.
    #
    # @return String
    def normalize_utf8!
      unicode_normalize!(:nfc)
      to_s
    end

    # Strip any leading digits.
    #
    # @return String
    def strip_leading_digits!
      gsub!(/^\d+/, "")
      to_s
    end

    # Attempt to convert characters encoded using CP1252 and IS0-8859-1 to
    # UTF-8.
    # @return String
    def tidy_bytes!
      scrub! do |bad|
        bad.encode(Encoding::UTF_8, Encoding::Windows_1252, invalid: :replace, undef: :replace)
      end
      to_s
    end

    %w[clean downcase normalize normalize_utf8 strip_leading_digits
       tidy_bytes to_ascii transliterate truncate truncate_bytes upcase
       with_separators word_chars].each do |method|
      class_eval(<<-METHOD, __FILE__, __LINE__ + 1)
        def #{method}(*args)
          with_new_instance { |id| id.send(:#{method}!, *args) }
        end
      METHOD
    end

    def to_ruby_method(allow_bangs: true)
      with_new_instance { |id| id.to_ruby_method!(allow_bangs: allow_bangs) }
    end

    def to_identifier
      self
    end

    # The default options for {#normalize!}. Override to set your own defaults.
    def default_normalize_options
      {transliterate: :latin, max_length: 255, separator: "-"}
    end

    alias approximate_ascii transliterate
    alias approximate_ascii! transliterate!
    alias with_dashes with_separators
    alias with_dashes! with_separators!
    alias to_slug to_identifier

    private

    # Used as the basis of the non-mutating (bangless) methods.
    def with_new_instance
      Identifier.allocate.tap do |id|
        id.instance_variable_set :@wrapped_string, to_s

        yield id
      end
    end
  end
end
