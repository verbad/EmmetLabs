module SortableColumns
  def self.included(base)
    base.extend         ClassMethods
    base.instance_eval { include InstanceMethods }
  end

  module ClassMethods
    def prevent_sorting_on(*args)
      sortable_columns_exclude.merge(args.collect {|a| a.to_s})
      if defined? @sortable_columns
        @sortable_columns = nil
      end
    end

    def sortable_columns
      if !(defined? @sortable_columns) || @sortable_columns.nil?
        ex = sortable_columns_exclude
        @sortable_columns = columns.select {|c| !ex.include?(c.name)}.collect {|c| c.name}
      end

      return @sortable_columns.clone
    end

    def select_columns(*args) 
      cols = args.flatten
      cols.select do |c|
        sortable_columns.include?(c.gsub(/_rev$/) {})
      end
    end

    def sort_by_to_sql(val = nil)
      if (val.nil?)
        val = params[:sort_by]
      end

      cols = select_columns(val.split(/\s*,\s*/)).collect do |col|
        if col.gsub!(/_rev$/) {}
          col += ' DESC'
        end
        col
      end
      cols.join(', ')
    end

    private
    def sortable_columns_exclude
      if !(defined? @sortable_columns_exclude) || @sortable_columns_exclude.nil?
        @sortable_columns_exclude = Set.new
      end
      @sortable_columns_exclude
    end
  end

  module InstanceMethods
  end
end