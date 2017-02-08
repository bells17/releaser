class ProductsController < ApplicationController
  def index
    limit = 20
    @page = (params[:page] || "1").to_i
    @products = Product.limit(limit).offset((@page - 1) * limit)
  end

  def show
    @product = Product.find(params[:id])
  end
end
