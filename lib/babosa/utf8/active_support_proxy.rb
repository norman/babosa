require 'active_support/multibyte/unicode'

module Babosa
  module UTF8
    # A UTF-8 proxy using Active Support's multibyte support.
    module ActiveSupportProxy
      extend UTF8Proxy
      extend self
      def downcase(string)
        ActiveSupport::Multibyte::Unicode.downcase(string)
      end

      def upcase(string)
        ActiveSupport::Multibyte::Unicode.upcase(string)
      end

      def normalize_utf8(string)
        ActiveSupport::Multibyte::Unicode.normalize(string)
      end

      def tidy_bytes(string)
        ActiveSupport::Multibyte::Unicode.tidy_bytes(string)
      end
    end
  end
end
