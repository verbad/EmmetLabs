#!/usr/bin/env ruby
def usage
  "USAGE: rake project:create PROJECT=[new project and directory name]\n" +
  "   OR: rake project:create PROJECT=[new project name] TARGET=[target directory]"
end

def create_svn_dir(dir)
  system "svn mkdir https://svn.pivotallabs.com/subversion/#{dir} -m'creating dir #{dir}'"
end

def svn_copy_dir(dir)
  system "svn copy https://svn.pivotallabs.com/subversion/sandbox/trunk https://svn.pivotallabs.com/subversion/#{dir} -m'creating #{dir}'"
end

def svn_checkout_dir(project, target_dir)
  system "svn co https://svn.pivotallabs.com/subversion/#{project}/trunk #{target_dir}"
end

def remove_svn_dir(dir)
  success = system "svn rm https://svn.pivotallabs.com/subversion/#{dir} -m'removing dir #{dir}"
  puts("Unable to remove #{dir} from SVN") unless success
  return success
end

def project_exists?(dir)
  puts "Checking to see if project #{dir} already exists in SVN..."
  system("svn list https://svn.pivotallabs.com/subversion/#{dir}")
end

def fail(message, &block)
  yield if block_given?
  puts "FAILURE: #{message}"
  exit(1)
end

namespace :project do
    desc "Checks out a project plugin"
    task :plugin do
      plugin_dir = ENV['DIR'] || "pivotal_core"
      plugin_name = ENV['NAME']
      # local forks of third_party code should live in branches/local, not trunk
      branch = (plugin_dir == 'third_party' ? 'branches/local' : 'trunk')
      if plugin_name
        system("ruby script/plugin install -x https://svn.pivotallabs.com/subversion/plugins/#{plugin_dir}/#{plugin_name}/#{branch}/#{plugin_name}")
      else
        puts "USAGE: rake project:plugin NAME=[pivotal core plugin name]"
        puts "   OR: rake project:plugin NAME=[plugin name] DIR=[plugin subdir]"
      end
    end


    desc "Creates a new project in Subversion"
    task :create do
      new_project = ENV['PROJECT']
      unless new_project
        puts "USAGE: rake project:create PROJECT=[new project and directory name]"
        puts "   OR: rake project:create PROJECT=[new project name] TARGET=[target directory]"
        exit(1)
      end

      target_dir = ENV['TARGET'] || new_project
      new_project_branches = "#{new_project}/branches"
      new_project_tags = "#{new_project}/tags"

      puts "creating project '#{new_project}' in dir '#{target_dir}'"

      # create project dirs

      if project_exists?(new_project)
        fail("Project #{new_project} already exists in SVN.  Please do a 'svn co'")
      end

      puts "Project #{new_project} not found in SVN.  It will now be created."
      create_svn_dir(new_project) || fail("could not create #{new_project} in SVN") {remove_svn_dir(new_project)}
      create_svn_dir new_project_branches || fail("could not create #{new_project_branches} in SVN") {remove_svn_dir(new_project)}
      create_svn_dir new_project_tags || fail("could not create #{new_project_tags} in SVN") {remove_svn_dir(new_project)}

      puts "doing svn copy now"

      svn_copy_dir(new_project) || fail("could not do svn copy to #{new_project} in SVN")

      puts "doing svn checkout now"
      svn_checkout_dir(new_project, target_dir)
    end
end
