require 'natives/host_detection'

module Natives
  module Apps
    class Detect

      def detection_info
        host = new_host_detection
        return [
          "platform: #{host.platform}",
          "platform_version: #{host.platform_version}",
          "package_provider: #{host.package_provider}",
        ].join("\n")
      end

      def new_host_detection
        HostDetection.new
      end
    end
  end
end
