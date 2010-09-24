# Build the configuration file from the samples.

config_files = []

namespace :init do
  FileList['**/*.sample'].each do |src|
    dest = src.chomp('.sample')
    config_files << dest
    file dest => src do
      copy src, dest
    end
  end

  desc "Copy config files from the bundled samples"
  task :config => config_files do
    puts "** Make sure you edit the config files for your local application **"
  end
end
