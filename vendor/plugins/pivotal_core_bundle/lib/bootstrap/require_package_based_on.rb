def require_package_based_on(dir)
  package_name = File.basename(dir)
  raise "Directory #{dir} does not exist. Should be a directory full of .rb files" unless File.exists?(dir)
  Dir["#{dir}/*.rb"].each do |file|
    if !File.directory?(file) && File.extname(file) == ".rb"
      filename = File.basename(file)#, ".rb")
      require "#{package_name}/#{filename}"
    end
  end
end