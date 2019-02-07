require "test_helper"
require 'active_filters'
require 'active_support'
require 'active_record'
require 'action_controller'

class ActiveFiltersTest < ActiveSupport::TestCase
  setup do
    @controller = UsersController.new
  end
  
  ::ActiveFilters::Setup.params_variable = '@params'
  
  class User < ActiveRecord::Base
    include ActiveFilters::Model::Filterable
  end

  class UsersController < ActionController::Base
    include ActiveFilters::Controller::Filterable

    def index(params)
      @params = params
      filterable_params
    end
  end

  test 'has_filters with in_key creates relevant filterable_params' do
    UsersController.has_filters(:country, :gender, in_key: :filter)
    params = {
      filter: {
        country: 'FR',
        gender: 'female',
        salut: 'yo'
      }
    }

    filterable_params = @controller.index(params)
  

    assert_equal 'FR', filterable_params[:country]
    assert_not filterable_params.key?(:salut)
  end

  test 'has_filters create filte' do
    UsersController.has_filters(:country, :gender)
    params = {
      country: 'FR',
      gender: 'female'
    }

    filterable_params = @controller.index(params)

    assert_equal 'female', filterable_params[:gender]
  end

  test 'method filter chains scopes' do
    User.expects(:country).with('FR').once.returns(User)
    User.expects(:gender).with('female').once.returns(User)
    User.expects(:salut).with('les filles').times(0)

    User.filter(country: 'FR', gender: 'female')
  end
end
