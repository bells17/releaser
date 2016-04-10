# == Schema Information
#
# Table name: products
#
#  id             :integer          not null, primary key
#  asin           :string(255)
#  isbn           :string(255)
#  title          :string(255)
#  binding        :string(255)
#  product_url    :text(65535)
#  image_small    :text(65535)
#  image_medium   :text(65535)
#  image_large    :text(65535)
#  price          :decimal(20, 6)
#  price_currency :string(255)
#  group          :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
