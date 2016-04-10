class ProductRegistService
  def initialize(item)
    @item = item
  end

  def regist
    product = item_to_product
    product.save
  end

  private
  def item_to_product
    product = Product.find_by(asin: @item.asin)
    product ||= Product.new
    product.asin = @item.asin
    product.isbn = @item.isbn
    product.title = @item.title
    product.binding = @item.binding
    product.product_url = @item.product_url
    product.image_small = @item.product_images[:small]
    product.image_medium = @item.product_images[:medium]
    product.image_large = @item.product_images[:large]
    product.price = @item.price
    product.price_currency = @item.price_currency
    product.group = @item.group
    product
  end

end
