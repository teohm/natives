require 'ohai'

module Natives
  class HostDetection
    class Platform

      def initialize
        @ohai = build_ohai
      end

      def name
        ohai_hash[:platform]
      end

      def version
        ohai_hash[:platform_version]
      end

      def ohai_hash
        @ohai
      end

      protected

      def build_ohai
        ohai = Ohai::System.new
        ohai.require_plugin 'os'
        ohai.require_plugin 'platform'
        ohai
      end

    end
  end
end
