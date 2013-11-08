module Natives
  class HostDetection
    class PackageProvider
      COMMANDS = {
        'aix' => 'installp',
        'yum' => 'yum',
        'packman' => 'packman',
        'apt' => 'apt-get',
        'feebsd' => 'pkg_add',
        'portage' => 'emerge',
        'homebrew' => 'brew',
        'macports' => 'port',
        'solaris' => 'pkg_add',
        'ips' => 'pkg',
        'zypper' => 'zypper',
        'smartos' => 'pkgin'
      }.freeze

      PROVIDERS = {
        'aix' => 'aix',
        'amazon' => 'yum',
        'arch' => 'pacman',
        'centos' => 'yum',
        'debian' => 'apt',
        'fedora' => 'yum',
        'freebsd' => 'freebsd',
        'gcel' => 'apt',
        'gentoo' => 'portage',
        'linaro' => 'apt',
        'linuxmint' => 'apt',
        'mac_os_x' => ['homebrew', 'macports'],
        'mac_os_x_server' => 'macports',
        'nexentacore' => 'solaris',
        'omnios' => 'ips',
        'openindiana' => 'ips',
        'opensolaris' => 'ips',
        'opensuse' => 'zypper',
        'oracle' => 'yum',
        'raspbian' => 'apt',
        'redhat' => 'yum',
        'scientific' => 'yum',
        'smartos' => 'smartos',
        'solaris2' => 'ips',
        'suse' => 'zypper',
        'ubuntu' => 'apt',
        'xcp' => 'yum',
        'xenserver' => 'yum'
      }.freeze

      def initialize(platform)
        @platform = platform
      end

      def name
        providers = Array(PROVIDERS[@platform.name])
        return providers.first if providers.count < 2

        providers.find do |provider|
          which(COMMANDS[provider]) != nil
        end
      end

      protected

      # copied from Chef cookbook 'apt'
      # source: apt/libraries/helpers.rb
      def which(cmd)
        paths = (
          ENV['PATH'].split(::File::PATH_SEPARATOR) +
          %w(/bin /usr/bin /sbin /usr/sbin /opt/local/bin)
        )

        paths.each do |path|
          possible = File.join(path, cmd)
          return possible if File.executable?(possible)
        end

        nil
      end

    end
  end
end
