require 'natives/host_detection/platform'
require 'natives/host_detection/package_provider'

module Natives
  class HostDetection

    def initialize(opts={})
      @detect_platform = opts.fetch(:detect_platform) { Platform.new }
      @detect_package_provider = opts.fetch(:detect_package_provider) {
        PackageProvider.new(@detect_platform) }
    end

    def platform
      @detect_platform.name
    end

    def platform_version
      @detect_platform.version
    end

    def package_provider
      @detect_package_provider.name
    end
  end
end
