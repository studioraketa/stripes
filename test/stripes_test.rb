require 'test_helper'
require 'minitest/mock'

class StripesTest < ActiveSupport::TestCase
  def assert_method_call(klass, method)
    params = {}
    order = 'Order'

    mock = MiniTest::Mock.new
    mock.expect(:call, true, [params, order])

    klass.stub(method, mock) { yield(params: params, order: order) }

    assert_mock mock
  end

  test '.card_payment' do
    assert_method_call(Stripes::Payments::Card, :create) do |params|
      Stripes.card_payment(params[:params], params[:order])
    end
  end

  test '.sofort_payment' do
    assert_method_call(Stripes::Payments::Sofort, :create) do |params|
      Stripes.sofort_payment(params[:params], params[:order])
    end
  end

  test '.giropay' do
    assert_method_call(Stripes::Payments::Giropay, :create) do |params|
      Stripes.giropay(params[:params], params[:order])
    end
  end

  test '.sofort_countries' do
    assert_equal %w[DE AT BE NL ES IT], Stripes.sofort_countries
  end

  test '.sofort_languages' do
    assert_equal %w[de en es it fr nl pl], Stripes.sofort_languages
  end
end
