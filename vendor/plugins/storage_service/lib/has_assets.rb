module HasAssets
  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  module ClassMethods
    def has_assets(*args, &block)
      cattr_accessor :asset_reflection
      self.asset_reflection = compute_options(args)

      has_many :assets_associations,
        :class_name => asset_reflection[:through].to_s.singularize.classify,
        :as => :associate,
        :order => :position,
        :dependent => :destroy
      has_many :assets,
        :class_name => asset_reflection[:klass].to_s,
        :through => :assets_associations,
        :source => :asset,
        :order => 'assets_associations.position', :extend => Module.new(&block) do
        define_method :build do |*params|
          asset = (Asset.new_by_file(params.first, proxy_owner.asset_reflection[:klass] == Asset ? nil : proxy_owner.asset_reflection[:klass]) rescue Asset.new)
          asset.assets_associations << proxy_owner.assets_associations.build
          asset
        end
        alias_method :new, :build
      end

      after_save :update_primary_assets_association

      include InstanceMethods

      alias_method "primary_#{asset_reflection[:assets].to_s.singularize}", :primary_asset
      alias_method "primary_#{asset_reflection[:assets].to_s.singularize}_id", :primary_asset_id
      alias_method "primary_#{asset_reflection[:assets].to_s.singularize}=", :primary_asset=
      alias_method "primary_#{asset_reflection[:assets].to_s.singularize}_id=", :primary_asset_id=
      alias_method asset_reflection[:assets], :assets
      alias_method "#{asset_reflection[:assets].to_s.singularize}=", :asset=
    end

    def compute_options(args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      assets = args.shift || :assets
      default_options = {
        :through => :assets_associations,
        :assets => assets,
        :class_name => assets.to_s.singularize.classify,
      }
      options = default_options.merge(options)
      options[:klass] = options[:class_name].constantize
      options[:default] = (options[:default] || options[:class_name]).constantize
      options
    end
  end

  module InstanceMethods
    def primary_asset
      @primary_asset ||
        ((primary_association = assets_associations.find_by_primary(true)) && primary_association.asset) ||
        DefaultPhoto.new(self.class.asset_reflection[:default])
    end

    def primary_asset=(asset)
      @primary_asset = asset
    end

    def primary_asset_id=(id)
      self.primary_asset = Asset.find(id)
    end

    def primary_asset_id
      primary_asset.id
    end

    def asset=(upload)
      if upload && !upload.blank?
        assets_associations.build(:asset => asset_reflection[:klass].new_from_upload(:data => upload))
      end
    end

    def update_primary_assets_association
      if @primary_asset
        old_primary = assets_associations.find_by_primary(true)
        if old_primary
          old_primary.primary = false
          old_primary.save
        end
        new_primary = assets_associations.find_by_asset_id(@primary_asset)
        if new_primary
          new_primary.primary = true
          new_primary.save
        else
          assets_associations.create(:asset => @primary_asset)
        end
      end
    end
  end
end

class ActiveRecord::Base
  include HasAssets
end