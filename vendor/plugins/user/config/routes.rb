resources :password_reset_requests
resource :terms_of_service, :controller => :terms_of_service
resources :tos_revisions
resource :login, :controller => :login

resources :users do |user|
  user.resource :password, :controller => 'password'
  user.resources :email_addresses do |email_address|
    email_address.resources :verification_requests,
      :name_prefix => 'email_address_',
      :controller => 'email_address_verification_requests'
  end
  user.resource :profile, :controller => 'profile' do |profile|
    profile.resource :primary_photo,
      :name_prefix => 'profile_',
      :controller => 'primary_profile_photo'
    profile.resources :photos,
      :name_prefix => 'profile_',
      :controller => 'profile_photos'
  end
end

namespace(:admin) do |admin|
  admin.resource :home
  admin.resources :users 
end

admin "/admin", :controller => 'admin/homes', :action => 'show'

