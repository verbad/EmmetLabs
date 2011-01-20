ActionController::Routing::Routes.draw do |map|
  map.resources :content_pages

  map.routes_from_plugin(:user)

  map.connect '', :controller => 'start', :action => 'show'
  map.home_page '', :controller => 'start', :action => 'show'
  map.connect  'start/here', :controller => 'start', :action => 'start_here'

  map.resources :people do |person|
    person.resources :person_images
    person.resources :milestones
  end
  map.person_connections 'people/:node_id/connections', :controller => 'directed_relationships', :action => 'new'
  map.formatted_person_connections 'people/:node_id/connections.:format', :controller => 'directed_relationships', :action => 'new'

  # Person pseudo-resources
  %w(summary biography tags).each do |attribute|
    map.send "person_#{attribute}", "people/:node_id/#{attribute}", :controller => 'entity_attributes', :action => 'update', :node_type => 'person', :conditions => {:method => :put}
    map.send "formatted_person_#{attribute}", "people/:node_id/#{attribute}.:format", :controller => 'entity_attributes', :action => 'update', :node_type => 'person', :conditions => {:method => :put}
  end

  map.resources :entities do |entity|
    entity.resources :further_readings
    entity.resources :images
    entity.resources :milestones
  end
  map.entity_connections 'entities/:node_id/connections', :controller => 'directed_relationships', :action => 'new'
  map.formatted_entity_connections 'entities/:node_id/connections.:format', :controller => 'directed_relationships', :action => 'new'

  # Entity pseudo-resources
  %w(summary backgrounder further_reading tags).each do |attribute|
    map.send "entity_#{attribute}", "/entities/:node_id/#{attribute}", :controller => 'entity_attributes', :action => 'update', :node_type => 'entity', :conditions => {:method => :put}
    map.send "formatted_entity_#{attribute}", "/entities/:node_id/#{attribute}.:format", :controller => 'entity_attributes', :action => 'update', :node_type => 'entity', :conditions => {:method => :put}
  end

  map.resources :directed_relationships do |directed_relationship|
    directed_relationship.resources :directed_relationship_categories    
  end
  map.resources :nodes
  
  map.resources :relationship_stories
  map.resources :relationships do |relationship|
    relationship.resources :relationship_images
    relationship.resources :relationship_articles
    relationship.resources :relationship_comments
    relationship.resources :relationship_summaries
    relationship.resources :relationship_bibliographies
  end
  map.resources :relationship_metacategories #FIXME: moved under admin?
  map.resources :relationship_categories #FIXME: moved under admin?
  map.resources :photos do |photo|
    photo.resources :photo_comments
  end
  map.resources :stories
  map.resources :photos_associations
  map.resources :primary_photos_associations
  map.resources :network
  map.resources :tools
  map.resources :subscribers

  map.resource :start
  map.resources :welcome, :controller => 'welcome'


  map.connect 'team', :controller => 'welcome', :action => 'team'

  map.connect 'company', :controller => 'welcome', :action => 'company'
  map.connect 'about', :controller => 'welcome', :action => 'about'
  map.connect 'team', :controller => 'welcome', :action => 'team'
  map.connect 'contact', :controller => 'welcome', :action => 'contact'
  map.connect 'legal', :controller => 'welcome', :action => 'legal'

  map.milestones_xml 'milestones/index/:node_id.xml', :controller => 'milestones', :action => 'index'
  map.viewer 'view/:node_type/:id', :controller => 'viewers', :action => 'show'
  map.resource :search_results
  map.resources :amazon_search_results
  map.resources :person_suggestions
  map.resources :node_suggestions

  # FIXME: Routes should work in almost all cases, but collisions of name-id are possible with more entity types
  map.connect 'pair/:from_id/:to_id.:format', :controller => 'directed_relationships', :action => 'show'
  map.connect 'pair/:from_id/:to_id', :controller => 'directed_relationships', :action => 'show' 

  # end FIXME
  
  map.connect 'pages/:name', :controller => 'content_pages', :action =>'show'
  
  map.namespace(:admin) do |admin|
    admin.resource :home_page_relationships
    admin.resources :content_pages
    admin.resources :people, :member => {:migrate_to_entity => :post}
    admin.resources :entities
    admin.resources :relationships
    admin.resources :relationship_categories
    admin.resources :relationship_metacategories
    admin.resources :user_actions
  end

  #map.connect '*path', :controller => 'application', :action => 'render_404' unless ::ActionController::Base.consider_all_requests_local
  map.error '*path', :controller => 'application', :action => 'render_404' unless ::ActionController::Base.consider_all_requests_local
end
