# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
# config.action_view.debug_rjs                         = true

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

POST_LOAD_BLOCKS << Proc.new {
  silence_warnings {Synthesis::AssetPackageHelper::USE_COMPRESSED_CSS_AND_JS = false}
}

#POST_LOAD_BLOCKS << Proc.new {
#  unless Object.const_defined?(:STORAGE_SERVICE)
#    ::STORAGE_SERVICE = ::LocalDiskStorageService.new(RAILS_ROOT + "/public/assets/", "/assets/")
#    ::MESSAGE_CENTER_DOMAIN = "localhost"
#  end
#}

S3_ACCESS_KEY_FILENAME = RAILS_ROOT + "/config/s3-keys/aws_access.key"
S3_SECRET_KEY_FILENAME = RAILS_ROOT + "/config/s3-keys/aws_secret.key"

POST_LOAD_BLOCKS << Proc.new {
  unless Object.const_defined?(:STORAGE_SERVICE)
    access_key = S3StorageService.read_access_key(S3_ACCESS_KEY_FILENAME)
    secret_key = S3StorageService.read_access_key(S3_SECRET_KEY_FILENAME)
    ::STORAGE_SERVICE = S3StorageService.new("demo.emmetlabs.com", access_key, secret_key, {:use_as_domain => false})
    ::MESSAGE_CENTER_DOMAIN = "localhost"
  end
}
