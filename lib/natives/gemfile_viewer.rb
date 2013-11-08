module Natives
  class GemfileViewer
    def initialize(gemfile_path)
      @gemfile_path = gemfile_path
    end

    def gem_names
      extract_gem_names(bundle_list(@gemfile_path))
    end

    protected

    def bundle_list(gemfile_path)
      # after trial-and-error, these steps work best:
      # 1. cd to dir containing the gemfile
      # 2. bundle list
      dir = File.expand_path(File.dirname(@gemfile_path))
      filename = File.basename(@gemfile_path)
      output = %x{cd '#{dir}' && BUNDLE_GEMFILE=#{filename} bundle list 2>&1}
      successful_run = ($?.exitstatus == 0)

      unless successful_run
        raise "Cannot list gems in gemfile #{@gemfile_path.inspect}: #{output}"
      end

      output
    end

    def extract_gem_names(output)
      lines = output.split("\n")
      lines.shift # remove first line
      lines.map do |line|
        _, name, _ = line.split(" ")
        name
      end
    end
  end
end
