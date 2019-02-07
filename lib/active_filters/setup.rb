module ActiveFilters
  class Setup
    @params_variable = 'params'

    class << self
      attr_accessor :params_variable
    end

    def self.configure
      yield self
    end
  end
end