class AmazonapiService
  def initialize(params, logger)
    @logger = logger
    @access_key_id = params.access_key_id
    @sercret_access_key = params.sercret_access_key
    @associate_tag = params.associate_tag
  end

  def fetch_items(file, keyword, opts)
    today = Date.today.strftime("%Y%m%d")
    @logger.info "AmazonapiService fetch_items called: File: #{file} Keyword: '#{keyword}' opts: #{opts.to_s}"
    (1..10).each do |page|
      @logger.info "Date: #{today} Page: #{page} start"
      items = items_from_item_search("#{file}-#{today}-#{page}.xml", keyword, opts.merge({
        :item_page => page,
        :sort => "daterank"
      }))
      items.each do |item|
        product_regist_service = ProductRegistService.new(item)
        product_regist_service.regist
      end        
    end
  end

  def items_from_item_search(file, keyword, opts = {})
    path = file_path(file)
    if File.exist?(path)
      xml = Amazon::Ecs::Response.new(File.open(path))
    else
      xml = item_search_to_file(path, keyword, opts)
      return [] if xml.nil? or xml.items.nil?
    end
    parse_items_from_xml(xml)
  end

  private
  def default_api_opts
    {
      :AWS_access_key_id => @access_key_id,
      :AWS_secret_key => @sercret_access_key,
      :associate_tag => @associate_tag,
      :country => 'jp'
    }
  end

  def file_path(file)
    "#{Settings.path.tmp_files}/#{file}"
  end

  # item_search api の検索結果をファイルに保存します
  # @param [String] path      ファイルパス
  # @param [String] keyword   検索キーワード
  # @param [Hash]   opts      クエリオプション
  # @raise [SystemCallError, IOError]   ファイル書き込みが失敗した場合
  # @raise [Amazon::RequestError]       Amazon の API へのリクエストが失敗した場合
  # @return [String]  Amazon の API からエラーが返った場合はエラーメッセージ
  # @return [nil]     成功の場合はnil
  def item_search_to_file(path, keyword, opts = {})
    res = item_search(keyword, opts)
    if res.has_error?
      return res.error
    end
    File.open(path, "w") do |file|
      file.puts res.doc.to_xml
    end
    return res
  end

  # item_search api をコールする 一定回数失敗したら例外を投げる
  def item_search(keyword, opts = {})
    res = nil
    Retryable.retryable(:tries => 3, :sleep => 1, :on => Amazon::RequestError) do
      res = Amazon::Ecs.item_search(keyword, default_api_opts.merge(opts))
    end
    return res
  end

  def parse_items_from_xml(xml)
    xml.items.map do |item|
      Item.new(item)
    end
  end

  class Item
    attr  :title,
          :asin,
          :isbn,
          :binding,
          :product_url,
          :product_images,
          :price,
          :price_currency,
          :group,
          :authors,
          :categories

    def initialize(item)
      @title = item.get('ItemAttributes/Title')
      @asin = item.get("ASIN")
      @isbn = item.get("ItemAttributes/ISBN")
      @binding = item.get('ItemAttributes/Binding')
      @product_url = item.get('DetailPageURL')
      @product_images = {
        :small => item.get("SmallImage/URL"),
        :medium => item.get("MediumImage/URL"),
        :large => item.get("LargeImage/URL")
      }
      @price = item.get("ItemAttributes/ListPrice/Amount")
      @price_currency = item.get("ItemAttributes/ListPrice/CurrencyCode")
      @group = item.get("ItemAttributes/ProductGroup")
      @authors = (lambda {
        authors = []
        authors.push({ :type => "author", :name => item.get('ItemAttributes/Author') })
        creators = item.get_elements('ItemAttributes/Creator')
        (creators || []).each do |creator|
          role = creator.attributes.find { |attribute|
            attribute[0] == "Role"
          }
          role = role[1].value
          authors.push({
            :type => role,
            :name => creator.get
          })
        end
        authors
      }).call
      @categories = (lambda {
        node = item.get_element("BrowseNodes/BrowseNode")
        def append_to_parent(categories, node)
          categories = {
            :id => node.get("BrowseNodeId"),
            :name => node.get("Name"),
            :child => categories.size == 0 ? nil : categories.clone
          }
          next_node = node.get_element("Ancestors/BrowseNode")
          if next_node
            return append_to_parent(categories, next_node)
          end
          return categories
        end
        append_to_parent({}, node)
      }).call
    end
  end

end
