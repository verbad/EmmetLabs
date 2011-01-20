module ActiveRecord
  module Associations
    class AssociationCollection
      def new(options = {})
        ::Object.returning proxy_reflection.klass.new(options) do |instance|
          set_belongs_to_association_for(instance)
        end
      end
    end

    class HasManyAssociation < AssociationCollection
      def method_missing(method, *args, &block)
        if @target.respond_to?(method) || (!@reflection.klass.respond_to?(method) && Class.respond_to?(method))
          super
        else
          create_scoping = {}
          set_belongs_to_association_for(create_scoping)

          @reflection.klass.send(:with_scope,
            :create => create_scoping,
            :find => {
              :conditions => @finder_sql,
              :joins      => @join_sql,
              :order      => @reflection.options[:order], # I added just this line - nk,
              :include    => @reflection.options[:include], # and this one!
              :readonly   => false
            }
          ) do
            @reflection.klass.send(method, *args, &block)
          end
        end
      end
    end
    
    module Accessors
      def lazy_build(*attributes)
        options = attributes.last.is_a?(Hash) ? attributes.pop : {}
        attributes.each do |attribute|
          define_method "#{attribute}_with_lazy_initialization" do
            send("#{attribute}_without_lazy_initialization") || send("build_#{attribute}", options)
          end
          alias_method_chain attribute, :lazy_initialization
        end
      end
    end
  end
end

ActiveRecord::Base.send(:extend, ActiveRecord::Associations::Accessors)
