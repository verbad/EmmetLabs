require 'pp'
class Photoable < Module
  def initialize(photo_class, options={})
    defaults = {
      :extension => 'png',
      :cardinality => :multiple_photos,
      :association_class => AssetsAssociation
    }
    options = defaults.merge(options)

    extension = options[:extension]
    cardinality = options[:cardinality]
    @@association_class = options[:association_class]

    super() do
      def self.included(a_module)
        a_module.instance_eval do
          validates_associated :different_photo
          
          after_save :replace_photo_if_necessary

          has_many :assets_associations, :as => :associate,
          :order => :position, :class_name => @@association_class.to_s, :dependent => :destroy

          has_many :photos, :through => :assets_associations,
            :class_name => 'Photo',
            :as => :associate,
            :source => :asset,
            :order => 'assets_associations.position' do
            
            def first
              self.find(:first)
            end
            
            def << (photo)
              proxy_owner.assets_associations.create!(:asset => photo)
            end
          end
        end
      end

      define_method :primary_photo_from_upload do |upload, photo_creator|
        if upload && !upload.blank?
          self.primary_photo = photo_class.new_from_upload({}, upload)
          self.primary_photo.creator = photo_creator
        end
      end


      define_method :the_photo_class do
        photo_class
      end

      define_method :primary_photo do
        @different_photo || photos.first || DefaultPhoto.new(photo_class, extension)
      end

      define_method :primary_photo= do |new_photo|
        if cardinality == :single_photo
          @different_photo = new_photo
        else
          if photos.include?(new_photo)
            assets_associations.find_by_asset_id(new_photo.id).move_to_top
          else
            assets_associations.create!(:asset => new_photo).move_to_top
          end
        end
      end
      
      define_method :different_photo do
        @different_photo
      end

      define_method :replace_photo_if_necessary do
        if @different_photo
          assets_associations.destroy_all
          assets_associations.create!(:asset => @different_photo)
        end
        @different_photo = nil
      end
    end
  end
end
