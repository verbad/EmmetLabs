module Synthesis
  module AssetPackageHelper

    def self.use_packaged_assets
      silence_warnings {const_set(:USE_COMPRESSED_CSS_AND_JS, true)}
      Synthesis::AssetPackage.delete_all
      Synthesis::AssetPackage.build_all
    end

    def use_compressed_css_and_js?
      return @use_compressed_css_and_js_override unless @use_compressed_css_and_js_override.nil?
      Synthesis::AssetPackageHelper.const_defined?(:USE_COMPRESSED_CSS_AND_JS) && USE_COMPRESSED_CSS_AND_JS
    end

    def javascript_include_merged(*sources)
      options = sources.last.is_a?(Hash) ? sources.pop.stringify_keys : { }

      if sources.include?(:defaults) 
        sources = sources[0..(sources.index(:defaults))] + 
          ['prototype', 'effects', 'dragdrop', 'controls'] + 
          (File.exists?("#{RAILS_ROOT}/public/javascripts/application.js") ? ['application'] : []) + 
          sources[(sources.index(:defaults) + 1)..sources.length]
        sources.delete(:defaults)
      end

      sources.collect!{|s| s.to_s}
      sources = (use_compressed_css_and_js? ?
        AssetPackage.targets_from_sources("javascripts", sources) : 
        AssetPackage.sources_from_targets("javascripts", sources))
        
      sources.collect {|source| javascript_include_tag(source, options) }.join("\n")
    end

    def stylesheet_link_merged(*sources)
      options = sources.last.is_a?(Hash) ? sources.pop.stringify_keys : { }

      sources.collect!{|s| s.to_s}
      sources = (use_compressed_css_and_js? ?
        AssetPackage.targets_from_sources("stylesheets", sources) : 
        AssetPackage.sources_from_targets("stylesheets", sources))

      sources.collect { |source|
        source = stylesheet_path(source)
        tag("link", { "rel" => "Stylesheet", "type" => "text/css", "media" => "screen", "href" => source }.merge(options))
      }.join("\n")    
    end

    private
      # rewrite compute_public_path to allow us to not include the query string timestamp
      # used by ActionView::Helpers::AssetTagHelper
      # Hacked by NW to get correct . treatment
      def compute_public_path(source, dir, ext=nil, add_asset_id=true)
        source  = "/#{dir}/#{source}" unless source.first == "/" || source.include?(":")
        last_source = source.split("/").last

        source << ".#{ext}" unless ext.blank? || (last_source.include?(".") && ["jpg", "gif", "png"].include?(last_source.split(".").last))
        source << '?' + rails_asset_id(source) if defined?(RAILS_ROOT) && %r{^[-a-z]+://} !~ source && add_asset_id
        source  = "#{@controller.request.relative_url_root}#{source}" unless %r{^[-a-z]+://} =~ source
        source = ActionController::Base.asset_host + source unless source.include?(":")
        source
      end
  
      # rewrite javascript path function to not include query string timestamp
      def javascript_path(source)
        compute_public_path(source, 'javascripts', 'js', false)
      end

      # rewrite stylesheet path function to not include query string timestamp
      def stylesheet_path(source)
        compute_public_path(source, 'stylesheets', 'css', false)
      end

  end
end