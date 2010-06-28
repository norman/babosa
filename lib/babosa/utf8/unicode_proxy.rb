module Babosa
  module UTF8
    module UnicodeProxy
      extend UTF8Proxy
      extend self
      def downcase(string)
        Unicode.downcase(string)
      end

      def upcase(string)
        Unicode.upcase(string)
      end

      def normalize_utf8(string)
        Unicode.normalize_C(string)
      end
    end
  end
end
