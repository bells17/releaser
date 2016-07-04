namespace :amazonapi do
  desc "item_search"
  task :item_search => :environment do
    TaskUtil.exec "amazonapi_item_search", lambda { |logger|
      today = Date.today.strftime("%Y%m%d")
      amazonapi = AmazonapiService.new(Settings.api.amazon)
      (1..10).each do |page|
        logger.info "Date: #{today} Page: #{page} start"
        items = amazonapi.items_from_item_search("lite_novel-#{today}-#{page}.xml", "ライトノベル", {
          :search_index => "Books",
          :response_group => "Large",
          :Item_page => page,
          :sort => "daterank"
        })
        items.each do |item|
          product_regist_service = ProductRegistService.new(item)
          product_regist_service.regist
        end        
      end
    }
  end
end
