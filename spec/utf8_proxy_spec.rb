# encoding: utf-8
require File.expand_path("../spec_helper", __FILE__)

PROXIES = [Babosa::UTF8::DumbProxy, Babosa::UTF8::ActiveSupportProxy, Babosa::UTF8::UnicodeProxy]
PROXIES << Babosa::UTF8::JavaProxy if Babosa.jruby15?

PROXIES.each do |proxy|

  describe proxy do

    describe "#normalize_utf8" do
      it "should normalize to canonical composed" do
        # ÅÉÎØÜ
        uncomposed_bytes  = [65, 204, 138, 69, 204, 129, 73, 204, 130, 195, 152, 85, 204, 136]
        composed_bytes    = [195, 133, 195, 137, 195, 142, 195, 152, 195, 156]
        uncomposed_string = uncomposed_bytes.pack("C*").unpack("U*").pack("U*")
        proxy.normalize_utf8(uncomposed_string).unpack("C*").should eql(composed_bytes)
      end
    end

    describe "#upcase" do
      it "should upcase the string" do
        proxy.upcase("åéîøü").should eql("ÅÉÎØÜ")
      end
    end

    describe "#downcase" do
      it "should downcase the string" do
        proxy.downcase("ÅÉÎØÜ").should eql("åéîøü")
      end
    end

  end
end