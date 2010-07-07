module Babosa
  module UTF8
    # A UTF-8 proxy using Active Support's multibyte support.
    module ActiveSupportProxy
      extend UTF8Proxy
      extend self
      def downcase(string)
        ActiveSupport::Multibyte::Chars.new(string).downcase.to_s
      end

      def upcase(string)
        ActiveSupport::Multibyte::Chars.new(string).upcase.to_s
      end

      def normalize_utf8(string)
        ActiveSupport::Multibyte::Chars.new(string).normalize(:c).to_s
      end
    end
  end
end
