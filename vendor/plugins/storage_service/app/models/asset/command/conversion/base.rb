class Asset::Command::Conversion::Base < Asset::Command::Base
  def exec(cmd)
    `#{cmd}`
  end

  def do(data)
    process(data.path, result_path = destination_filename(data.path))
    File.open(result_path)
  end
end