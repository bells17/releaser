namespace :amazonapi do
  desc "item_search"
  task :item_search => :environment do
    TaskUtil.exec "amazonapi_item_search", lambda { |logger|
      amazonapi = AmazonapiService.new(Settings.api.amazon)
      items = amazonapi.items_from_item_search("lite_novel.xml", "ライトノベル", {
        :search_index => "Books",
        :response_group => "Large"
      })
      items.each do |item|
        product_regist_service = ProductRegistService.new(item)
        product_regist_service.regist
      end
    }
  end
end
