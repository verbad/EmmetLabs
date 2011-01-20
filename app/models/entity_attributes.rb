module EntityAttributes

  def self.included(base)
    base.extend         ClassMethods
    base.instance_eval { include InstanceMethods }
    base.class_eval do
      has_many :milestones, :as => :node, :dependent => :destroy, :order => 'year, month, day' # TODO: Move milestones for Entities once they are displayed

      has_many :user_actions, :as => :loggable, :dependent => :destroy
      has_many :users, :through => :user_actions

      has_assets :photos, :class_name => 'Photo', :through => :assets_associations

      acts_as_taggable_on :tags

      # TODO: This should be refactored to use the act_as_taggable_on helpers rather than querying the DB directly.
      def tags_shared_with(taggable, context = 'tags')
        tags.find(:all, :conditions => ["id IN (SELECT tag_id FROM taggings WHERE taggable_id = ? AND taggable_type = ? AND context = ?)", taggable.id, taggable.class.name, context])
      end

      validates_presence_of :summary, :message => 'Summary is required'
      validates_length_of :summary, :maximum => 150, :message => 'Too many characters (150 maximum)'

      validates_presence_of :calculated_dashified_full_name, :message => "Please enter a First and Last name and/or an Alias."

      has_many :directed_relationships, :as => :from, :dependent => :destroy do
        def in_metacategory(metacategory)
          find(:all, :conditions => ["category_id IN (SELECT id FROM relationship_categories WHERE metacategory_id = ?)", metacategory.id])
        end

        def in_no_metacategory
          find(:all, :conditions => "category_id IN (SELECT id FROM relationship_categories WHERE metacategory_id IS NULL)")
        end

        def in_category(category)
          find(:all, :conditions => ["category_id = ?", category.id]) # TODO: perhaps restore this sorting? , :include => :to, :order => 'people.calculated_full_name ASC')
        end

        def categories
          RelationshipCategory.find(:all, :conditions => "id")
        end

        def to(other_entity)
          find(:first, :conditions => ["to_id = ? AND to_type = ?", other_entity.id, other_entity.class.name])
        end

        def last_week
          find(:all, :conditions => ["directed_relationships.created_at > ? ", 7.days.ago])
        end

        def relatives
          all(:include => :to).collect { |dr| dr.to }
        end
      end
      has_many :relationships_directed_at_me, :as => :to, :class_name => "DirectedRelationship", :dependent => :destroy

      named_scope :sorted_by_full_name, :order => 'calculated_dashified_full_name'

      # CHANGED: this named_scope is superceded by a method of the same name
      # named_scope :sorted_by_relationship_count_and_full_name do
      #   { :order => 'count(directed_relationships)', :conditions => ['people.id = directed_relationships.from_id'], :group_by => 'directed_relationships.from_id'}
      # end

      named_scope :unrelated_to, lambda { |record|
        { :conditions => [<<-SQL,
            id != :from_id
            AND id NOT IN(
              SELECT to_id
              FROM directed_relationships
                WHERE from_type = :record_class
                AND from_id = :from_id
            )
          SQL
        {:from_id => record.id, :record_class => record.class.name}] }
      }

      named_scope :with_primary_asset,
        :include => {:assets => :versions},
        :conditions => ['assets_associations.primary = ?', true],
        :order => "#{self.table_name}.id"

      after_update do |record|
        action_log(record, 'update')
      end

      after_create do |record|
        action_log(record, 'create')
      end
    end
  end

  module ClassMethods
    EXPLORE_PER_PAGE = 48
    MAX_EXPLORE_PER_PAGE = 99
    SEARCH_PER_PAGE = 10
    MAX_SEARCH_PER_PAGE = 50

    def find_by_param(param)
      tokens = param.split('_')
      dashified_full_name = tokens.first
      id = tokens.last.to_i
      entity = find_by_id(id)
      return nil if entity.nil? || entity.calculated_dashified_full_name != dashified_full_name
      entity
    end

    def relationship_count_options
      {
        :joins => <<-SQL,
            LEFT OUTER JOIN directed_relationships
              ON directed_relationships.from_type = #{quote_value self.name}
              AND directed_relationships.from_id = #{table_name}.id
          SQL
        :group => "#{table_name}.id",
        :order => 'count(concat(directed_relationships.from_id, directed_relationships.from_type)) desc, calculated_dashified_full_name asc',
      }
    end
    
    def sorted_by_relationship_count_and_full_name(page_number=1, per_page=EXPLORE_PER_PAGE)
      per_page = MAX_EXPLORE_PER_PAGE if per_page > MAX_EXPLORE_PER_PAGE
      
      find_options = {
        :per_page => per_page,
        :page => page_number
      }.merge(relationship_count_options)
      paginate(find_options)
    end

    def most_recent_connections(number=5)
      find_options = {
        :conditions => ['directed_relationships.created_at > ?', 7.days.ago],
        :limit => number
      }.merge(relationship_count_options)
      all(find_options)
    end

    def most_active_recently(number=5)
      most_active = UserAction.count(
      :group => 'loggable_id',
      :conditions => ['created_at > ? and loggable_type ="Person"', 7.days.ago],
      :limit => number,
      :order => 'count_all DESC'
      )

      if (most_active.nil? || most_active.empty?)
        find(:all, :limit => number, :order => 'created_at DESC')
      else
        by_id = find(:all, :conditions => ['id in (?)', most_active.map {|a| a[0]}]).index_by {|p| p.id}
        most_active.collect {|a| by_id[a[0]]}
      end
    end

    def action_log(entity, type)
      unless current_user.nil?
        ua = UserAction.create(:user_id => current_user.id,
        :action => type,
        :loggable_id => entity.id,
        :loggable_type => self.name )
      end
    end

    def mangle_default_photo(url)
      return url
    end
    
    def attach_primary_photos(collection)
      return [] if collection.blank?
      found_assets_associations = AssetsAssociation.find(:all,
      :conditions => {
        :primary => true, 
        :associate_type => collection.first.class.name, 
        :associate_id => collection.map { |i| i.id }
      },
      :include => {:asset => :versions}
      ).index_by { |a| a.associate_id }

      collection.each do |node|
        assoc = found_assets_associations[node.id]
        node.primary_asset = (assoc && assoc.asset) || DefaultPhoto.new(Photo)
      end
    end
  end

  module InstanceMethods
    def categories_with_relationships
      RelationshipCategory.find(:all, :conditions => ["id IN (SELECT category_id FROM directed_relationships WHERE from_id = ? AND from_type = ?)", self.id, self.class.name])
    end

    def relationship_supergroups
      metacategory_hash = {}
      categories_with_relationships.each do |category|
        if category.metacategory
          metacategory_hash[category.metacategory] ||= []
          metacategory_hash[category.metacategory] << RelationshipGroup.new(category, directed_relationships.in_category(category))
        end
      end

      list = []
      metacategory_hash.each do |key, value|
        list << RelationshipSupergroup.new(key, value)
      end
      list
    end

    def relationship_groups_not_in_supergroups
      list = []
      categories_with_relationships.each do |category|
        if category.metacategory.nil?
          list << RelationshipGroup.new(category, directed_relationships.in_category(category))
        end
      end
      list
    end

    def related_to?(entity)
      directed_relationship_to(entity)
    end

    def directed_relationship_to(entity)
      directed_relationships.find_by_to_id_and_to_type(entity.id, entity.class.name)
    end

    def <=>(other)
      self.full_name <=> other.full_name
    end

    def to_param
      "#{full_name.dashify}_#{id}"
    end

    def to_s
      full_name
    end
    alias_method :to_display_name, :to_s

    def to_xml(options = {})
      options[:indent] ||= 2
      xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
      xml.instruct! unless options[:skip_instruct]
      
      tag_name = self.class.name.underscore
      xml.tag!(tag_name, :id => id, :stub => stub?) do
        xml.name full_name
        xml.param to_param
        xml.primary_photo_url STORAGE_SERVICE.proxy_url(self.class.mangle_default_photo(primary_photo.versions[:small].url))
      end
    end

    def relatives
      directed_relationships.relatives
    end

    def relatives_with_primary_photo(depth = -1, stub_cache = Hash.new)
      nodes = []
      drs = directed_relations_set(depth, stub_cache)

      drs.group_by {|dr| dr.to_type }.each do |group_type, group|
        found_nodes = group_type.constantize.find(group.map { |n| n.to_id }.uniq.sort)
        nodes += self.class.attach_primary_photos(found_nodes)
      end
      
      nodes.each {|n| stub_cache.update_item(n)}
    end

    def with_relatives
      relatives.unshift(self)
    end

    def directed_relations_set(depth = -1, stub_cache = Hash.new)
      directed_relationship_nodes = Set.new(directed_relationships + relationships_directed_at_me)
      visited_nodes = Set.new(directed_relationship_nodes)
      tree = Set.new visited_nodes

      stub_cache.default = true

      # puts 'start ----------------------------------------------------'
      class <<stub_cache
        def update_item(item) 
          if item.is_a?(DirectedRelationship)
            # puts "UI D %7x %4d %30s -> %-30s %-5s [%s]" % [item.object_id, item.id, item.from.to_param, item.to.to_param, self[item.to.to_param], item.stub?]
            item.stub = self[item.to.to_param]
            item = item.to
          end
          # puts "UI N %7x %4d %-30s %-5s [%s]" % [item.object_id, item.id, item.to_param, self[item.to_param], item.stub?]
          item.stub = self[item.to_param]
        end

        def set_item(item, value)
          if item.is_a?(DirectedRelationship)
            # puts "SI D %7x %4d %30s -> %-30s %-5s [%s:%s]" % [item.object_id, item.id, item.from.to_param, item.to.to_param, value, self[item.to.to_param], item.stub?]
            item.stub = value
            item = item.to
          end
          # puts "SI N %7x %4d %-30s %s [%s:%s]" % [item.object_id, item.id, item.to_param, value, self[item.to_param], item.stub?]
          item.stub = self[item.to_param] = value
        end
      end

      if (depth == 0)
        relationships_directed_at_me.each do |dr|
          stub_cache.set_item(dr, false)
        end
      end

      until directed_relationship_nodes.empty? || depth == 0 do
        depth = depth - 1;

        directed_relationship_nodes.each do |dr|
          stub_cache.set_item(dr, false)
          stub_cache.set_item(dr.from, false)
        end

        visited_nodes.merge directed_relationship_nodes
        tree.merge directed_relationship_nodes

        visited_node_ids = visited_nodes.to_a.map { |n| n.id }.sort
        classified_nodes = Set.new(directed_relationship_nodes).classify { |n| n.from_type }
        directed_relationship_nodes = Set.new

        classified_nodes.each do |node_type, nodes|
          # WARNING: *******
          # the following query is special, it uses the ids in classified_nodes and 
          # maps them to directed_relationships in BOTH DIRECTIONS (as the #from and the #to)
          #neighbors = DirectedRelationship.find(:all, :conditions => [
          #  "((from_type = :type AND from_id IN(:ids)) OR (to_type = :type AND to_id IN(:ids))) AND id NOT IN(:visited_node_ids)", {
          #    :type => node_type,
          #    :ids => nodes.map { |n| n.from_id }.sort,
          #    :visited_node_ids => visited_node_ids
          #}])
          # Unfortunately, I need directionality to figure out stub status, and I think two queries will be faster than a O(n^2) search
          node_ids = nodes.map {|n| n.from_id}.sort
          neighbors = DirectedRelationship.find(:all, :conditions => ["to_type = :type AND to_id IN (:ids) AND id NOT IN (:visited_ids)", {
            :type => node_type,
            :ids => node_ids,
            :visited_ids => visited_node_ids
          }])

          neighbors.each do |neighbor|
            stub_cache.set_item(neighbor, false)
          end # "from_type = :type AND from_id IN (:ids) AND id NOT IN (:visited_ids)"

          neighbors += DirectedRelationship.find(:all, :conditions => ["from_type = :type AND from_id IN (:ids) AND id NOT IN (:visited_ids)", {
            :type => node_type,
            :ids => node_ids,
            :visited_ids => visited_node_ids
          }])

          neighbors.each do |neighbor|
            visited_nodes << neighbor
            directed_relationship_nodes << neighbor
            tree << neighbor
            stub_cache.update_item(neighbor)
          end
        end

      end

      # puts "Final update -----------------------------------"
      tree.each do |dr|
        stub_cache.update_item(dr)
        stub_cache.update_item(dr.from)
      end

      tree
    end
    
    def all_relations
      relations_accumulator = directed_relations_set.inject({}) do |mem, dr|
        mem[dr.from_type] ||= Set.new
        mem[dr.to_type] ||= Set.new
        mem[dr.from_type] << dr.from_id
        mem[dr.to_type] << dr.to_id
        mem
      end
      relations = []
      relations_accumulator.each do |k, v|
        relations += k.constantize.find(Array(v))
      end
      relations
    end
    
    def after_initialize 
      @stub = true
    end

    def stub?
      @stub
    end

    def stub=(value)
      # keep it strictly boolean
      @stub = value ? true : false
    end
        
    def attributes_for_entity
      self.attributes
    end
  end
end
