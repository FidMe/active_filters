require 'active_filters/version'
require 'active_support/all'
require 'active_record'
require_relative 'active_filters/setup'

module ActiveFilters
  module Model
    module Filterable
      extend ::ActiveSupport::Concern
      included do
        scope :with_filter, ->(filterable_params) {
          results = all
          (filterable_params || []).each do |key, value|
            results = results.public_send(key, value) if value.present?
          end
          results
        }
      end

      class_methods do
        def filter(params)
          with_filter(params)
        end
      end
    end
  end

  module Controller
    module Filterable
      extend ::ActiveSupport::Concern

      class_methods do
        def has_filters(*filters)
          filter_key = filters.last.is_a?(Hash) && filters.last[:in_key]
          filters.pop if filter_key

          define_method(:filterable_params) do
            return {} unless _get_filter_params(filter_key) && filters
            _get_filter_params(filter_key).slice(*filters)
          end
        end
      end

      def _get_filter_params(filter_key)
        _params = eval(::ActiveFilters::Setup.params_variable)
        (filter_key ? _params[filter_key] : _params)
      end
    end
  end
end
