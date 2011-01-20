require 'fileutils'

module PluginInstaller
  class Installer
    attr_accessor :rails_root
    attr_accessor :plugin_root

    def initialize()
      @rails_root = File.expand_path(File.dirname(__FILE__) + "/../../../")
      @plugin_root = File.expand_path(File.dirname(__FILE__))
    end

    def run
      PublicDirCopier.new(rails_root).run
      RouteAdder.new(rails_root).run
      MigrationAdder.new(rails_root, plugin_root).run
    end
  end

  class PublicDirCopier
    attr_accessor :rails_root

    def initialize(rails_root)
      @rails_root = rails_root
    end

    def run
      default_profile_photo_dir = "/public/images/default_profile_photo"

      to_dir = rails_root + default_profile_photo_dir
      FileUtils.mkdir_p(to_dir)

      from_dir = rails_root + "/vendor/plugins/user/install#{default_profile_photo_dir}"

      copy_image(from_dir, to_dir, 'avatar.png')
      copy_image(from_dir, to_dir, 'original.png')
    end
    
    private
    def copy_image(from_dir, to_dir, image_name)
      puts "Copying '#{image_name}' to #{to_dir}"
      FileUtils.cp(from_dir + "/" + image_name, to_dir)
    end
  end

  class RouteAdder
    attr_accessor :rails_root

    def initialize(rails_root)
      @rails_root = rails_root
    end

    def run
      route_file = "#{rails_root}/config/routes.rb"
      sentinel = 'ActionController::Routing::Routes.draw do |map|'
      gsub_file route_file, /(#{Regexp.escape(sentinel)})/mi do |match|
        "#{match}\n  map.routes_from_plugin(:user)\n"
      end
      puts "Adding user plugin route to #{route_file}"
    end

    private
    def gsub_file(path, regexp, *args, &block)
      content = File.read(path).gsub(regexp, *args, &block)
      File.open(path, 'wb') { |file| file.write(content) }
    end
  end

  class MigrationAdder
    attr_accessor :rails_root
    attr_accessor :plugin_root

    def initialize(rails_root, plugin_root)
      @rails_root = rails_root
      @plugin_root = plugin_root
    end

    def run
      new_migration_file = "#{rails_root}/db/migrate/#{current_migration_number_of(rails_root) + 1}_install_user_plugin.rb"
      FileUtils.touch(new_migration_file)
      File.open(new_migration_file, 'wb') { |file| file.write(content) }
      puts "Adding user plugin migration to #{new_migration_file}"
    end

    private
    def current_migration_number_of(path)
      Dir.glob("#{path}/db/migrate/[0-9]*_*.rb").inject(0) do |max, file_path|
        n = File.basename(file_path).split('_', 2).first.to_i
        if n > max then n else max end
      end
    end

    def content
      content_text = <<-EOF
class InstallUserPlugin < ActiveRecord::Migration
  def self.up
    migrate_plugin('user', #{current_migration_number_of(plugin_root)})
  end

  def self.down
    migrate_plugin('user', 0)
  end
end
      EOF
      content_text
    end
  end
end
