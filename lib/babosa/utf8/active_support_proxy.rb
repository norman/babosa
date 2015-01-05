require 'active_support/multibyte/unicode'

module Babosa
  module UTF8
    # A UTF-8 proxy using Active Support's multibyte support.
    module ActiveSupportProxy
      extend ActiveSupport::Multibyte::Unicode

      def self.normalize_utf8(string)
        normalize(string, :c)
      end
    end
  end
end
