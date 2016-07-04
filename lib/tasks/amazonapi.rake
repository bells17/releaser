namespace :amazonapi do
  desc "item_search"
  task :item_search => :environment do
    TaskUtil.exec "amazonapi_item_search", lambda { |logger|
      amazonapi = AmazonapiService.new(Settings.api.amazon, logger)
      amazonapi.fetch_items("lite_novel", "ライトノベル", {
        :search_index => "Books",
        :response_group => "Large"
      })
    }
  end
end
