require "active_filters/version"

module ActiveFilters
  module Model
    module Filterable
      extend ActiveSupport::Concern

      class_methods do
        def filter(filterable_params)
          results = all
          (filterable_params || []).each do |key, value|
            results = results.public_send(key, value) if value.present?
          end
          results
        end
      end
    end
  end

  module Controller
    module Filterable
      extend ActiveSupport::Concern

      class_methods do
        def has_filters(*filters)
          filter_key = filters.last[:in_key]
          filters.pop
          define_method(:filterable_params) do
            return {} unless @params[filter_key] && filters
            @params[filter_key].slice(*filters)
          end
        end
      end
    end
  end
end
