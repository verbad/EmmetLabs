# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def display_name_id_pairs(model_objects)
    model_objects.map {|model_object| [model_object.to_display_name, model_object.id]}
  end

  def select_related_model(model_name, attribute_name, related_model_objects)
    select(model_name, attribute_name, [["---", ""]] + display_name_id_pairs(related_model_objects))
  end
  
  def drop_down(model_name, attribute_name, related_model_objects, first_value = [])
    select(model_name, attribute_name, first_value + display_name_id_pairs(related_model_objects))
  end
  
  def markaby(&block)
    Markaby::Builder.new({}, self, &block).to_s
  end
  
  def hamlize(haml_text)
    Haml::Engine.new(haml_text.lstrip).render
  end

  def debug_in_development
    if RAILS_ENV=='development'
      markaby do
        div.debug do
          yield
        end
      end
    end
  end

  def flash_object_tag(url, width, height, flashvars_hash, bgcolor, show_upgrade_message = true)
    markaby do
      div.flashcontent!(:style => "width: #{width}; height: #{height}") do
        strong "You need to upgrade your Flash Player and enable Javascript to use this site" if show_upgrade_message
      end

      script(:type => "text/javascript") do
        text %{
		      // <![CDATA[
           var so = new SWFObject('#{url}', 'EmmetFlashApp', '#{width}', '#{height}', '9', '##{bgcolor}');
           so.addVariable("xmlURL", "#{flashvars_hash[:xml_url]}");
           so.addVariable("bgcolor", "0x#{bgcolor}");
           so.write("flashcontent");
       		// ]]>
         }
      end
    end
  end

  def pretty_directed_relationship_path(directed_relationship)
    "/pair/#{directed_relationship.from.to_param}/#{directed_relationship.to.to_param}"
  end

  def pretty_directed_relationship_path_xml(directed_relationship)
    "#{pretty_directed_relationship_path(directed_relationship)}.xml"
  end
  
  def ajax_directed_relationship_path(directed_relationship)
    # derivative value
    pretty_directed_relationship_path(directed_relationship).gsub(%r{^/pair/}) {$& + 'ajax/'}
  end
  
  def pretty_person_or_entity_path(node)
    if node.class == Person
      "/view/people/#{node.to_param}"
    else
      "/view/entity/#{node.to_param}"
    end
  end

  def m(text)
    markdown(text)
  end

  def milestone_date_fields(milestone, prefix)
    markaby do
      text select_tag("#{prefix}[month]", options_for_select(Date::ABBR_MONTHNAMES.map {|abbreviation| [abbreviation.nil? ? 'Month' : abbreviation, abbreviation.nil? ? '' : Date::ABBR_MONTHNAMES.index(abbreviation).to_s]}, milestone.nil? ? '' : milestone.month.to_s))
      text select_tag("#{prefix}[day]", options_for_select( (0..31).map {|index| [index == 0 ? 'Day' : index.to_s, index == 0 ? '' : index.to_s]}, milestone.nil? ? '' : milestone.day.to_s))
      value_for_year_field = 'Year'
      unless milestone.nil? or milestone.year.nil?
        if milestone.errors[:year]
          value_for_year_field = milestone.year_before_type_cast
        else
          value_for_year_field = milestone.year.abs
        end
      end
      text text_field_tag("#{prefix}[year]", value_for_year_field, :size => 4, :id => "#{prefix}_year")
      text select_tag("#{prefix}[year_multiplier]", options_for_select( [['BCE', '-1'], ['CE', '1']], (milestone.nil? || milestone.year.to_i >= 0) ? '1' : '-1'))
    end
  end

  def string_path(string)
    string
  end

  def revision_display_name(article)
    markaby do
      text "Revision #{article.revision} "
      author_and_ago(article)
    end
  end

  def author_and_ago(thing)
    markaby do
      span "#{time_ago_in_words(thing.created_at)} ago, ".capitalize
      span.unique_name { text thing.author.unique_name} if thing.author
    end
  end

  def markdown_link
    markaby do
      span {link_to 'Formatting guide (Markdown)', 'http://en.wikipedia.org/wiki/Markdown', :target => '_blank'}
    end
  end

  def pretty_content_page_path(content_page)
    "/pages/#{content_page.name.dashify}"
  end

  def update_summary_js(summary_div_id)
    hamlize <<-JS #javascript
      :javascript
        function update_summary_characters_remaining_#{summary_div_id}() {
          if ($('summary_error_#{summary_div_id}')) $('summary_error_#{summary_div_id}').hide();
          var remaining = 150 - ($('#{summary_div_id}')).value.length;
          var message = remaining < 0 ? '<span class = "error">Too many characters (150 maximum)</span>' : remaining + ' characters remaining';
          $('summary_countdown_#{summary_div_id}').innerHTML = message;
        }
      JS
  end

  def category_link(category, directed_relationship)
    klass = ''
    klass = 'category_selected' if directed_relationship.category == category
    markaby do
      function = capture do
        text <<-JS
          if ($('selected_directed_relationship_category').value) {
            $('category_' + $('selected_directed_relationship_category').value).className = '';
          }
          $('selected_directed_relationship_category').value = '#{category.id}';
          $('category_#{category.id}').className = 'category_selected';
        JS
      end
      div.category_links do
        link_to_function span(category.name), function, :id => "category_#{category.id}", :class => klass
      end
    end
  end
  
  def photo_link(photo, size)
    path = if photo.associates.first.class == Person
      network_path(photo.associates.first)
    else
      pretty_directed_relationship_path(photo.associates.first.directed_relationships.first)
    end
    link_to image_tag(photo.versions[size].url), path
  end
  
  def photo_association_link(photo)
    associate = photo.associates.first
    if associate.class == Person
      link_to("#{associate.full_name}", network_path(associate), :title => associate.full_name )
    else
      link_to("#{associate.directed_relationships.first.from.full_name} & #{associate.directed_relationships.first.to.full_name}", pretty_directed_relationship_path(associate.directed_relationships.first) )
    end
  end
  
  def current_user_valid?()
    !current_user.nil? && current_user.account_verified?
  end
  
  def show_pagination_count(count, current, page, cols)
    # truncate to an even number
    count = count.to_i / cols * cols
    newPage = (page.to_i * current.to_i / count)
    newPage = 1 if newPage < 1
    if count == current
      "Show #{count}"
    else
      link_to "Show #{count}", params.merge({:count => count, :page => newPage})
    end
  end
  
  def sort_by_link(text, col) 
    sort = params[:sort_by] || ''
    sort = sort.split(/,/)
    if col =~ /_rev$/
      base = col.gsub(/_rev$/) {}
      if sort[0] == base
        sort[0] = col
      elsif sort[0] == col
        sort[0] = base
      else
        sort.unshift(col)
      end
    else
      rev = "#{col}_rev"
      if (sort[0] == col)
        sort[0] = rev
      elsif (sort[0] == rev)
        sort[0] = col
      else
        sort.unshift(col)
      end
    end

    # Ugly special case for Admin::
    klass = params[:controller].gsub(%r{admin/}){}.singularize.camelize.constantize 
    cols = klass.sortable_columns

    found = {}
    
    sort = sort.select do |c|
      base = c.gsub(/_rev$/) {}
      if (!cols.include?(base) || !found[base].nil?)
        false #next
      else 
        found[base] = true
      end
    end
    
    link_to text, params.merge(:sort_by => sort.join(','))
  end
end
