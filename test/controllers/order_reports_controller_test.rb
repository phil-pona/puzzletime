require 'test_helper'

class OrderReportsControllerTest < ActionController::TestCase

  setup :login

  test 'GET index without filter has empty report' do
    get :index
    assert_equal false, assigns(:report).filters_defined?
  end

  test 'GET index with department filter contains correct entries' do
    get :index, department_id: departments(:devone).id
    assert_equal true, assigns(:report).filters_defined?
    assert_equal orders(:puzzletime, :webauftritt), assigns(:report).entries.collect(&:order)
  end

  test 'GET index with period filter contains correct entries' do
    get :index, start_date: '6.12.2006', end_date: '7.12.2006'
    assert_equal true, assigns(:report).filters_defined?
    assert_equal orders(:allgemein, :puzzletime), assigns(:report).entries.collect(&:order)
  end

  test 'GET index with invalid period filter shows error' do
    get :index, start_date: '31.12.2006', end_date: '1.12.2006'
    assert_equal false, assigns(:report).filters_defined?
    assert flash[:alert].present?
    assert_equal Period.new(nil, nil), assigns(:period)
  end

  test 'GET index csv exports csv file' do
    get :index, responsible_id: employees(:lucien).id, format: :csv
    assert_match /Kunde,Kategorie,Auftrag/, response.body
  end

end