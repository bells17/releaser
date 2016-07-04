namespace :amazonapi do
  namespace :item_search do
    desc "lite_novel"
    task :lite_novel => :environment do
      TaskUtil.exec "amazonapi_item_search", lambda { |logger|
        amazonapi = AmazonapiService.new(Settings.api.amazon, logger)
        amazonapi.fetch_items("lite_novel", "ライトノベル", {
          :search_index => "Books",
          :response_group => "Large"
        })
      }
    end
  end
end
