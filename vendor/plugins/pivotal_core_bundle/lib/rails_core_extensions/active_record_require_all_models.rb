require 'active_record'
module ActiveRecordRequireAllModels
  def require_all_models
    model_dir = "#{RAILS_ROOT}/app/models"
    Dir.glob("#{model_dir}/**/*.rb").each do |full_path|
      require_dependency File.basename(full_path, ".rb")
    end
  end
end

class ActiveRecord::Base
  extend ActiveRecordRequireAllModels
  include ActiveRecordRequireAllModels
end
