class PocketItem
  attr_accessor :id, :title, :url, :excerpt, :asset_src, :timestamp, :bookmark_count, :archive_flg

  BASE_URL = 'https://getpocket.com/v3/'

  def initialize(data)
    @id = data['item_id']
    @title =
      if data['resolved_title'].empty?
        data['given_title'].empty? ? data['resolved_url'] : data['given_title']
      else
        data['resolved_title']
      end
    @url = data['resolved_url']
    @excerpt = data['excerpt']
    @asset_src = data['image']['src'] unless data['image'].nil?
    @timestamp = data['time_added'].to_i
    @archive_flg = false
  end

  def added_time
    Time.at(@timestamp).strftime("%Y/%m/%d")
  end


  def self.fetch_items(fetch_count, offset, since_time = nil, &block)
    url =
      if since_time.nil?
        "#{BASE_URL}get?consumer_key=#{MY_ENV['pocket']['consumer_key']}&access_token=#{PocketAPI.sharedAPI.pkt_getToken}" \
        "&count=#{fetch_count}&offset=#{offset}&detailType=complete"
      else
        "#{BASE_URL}get?consumer_key=#{MY_ENV['pocket']['consumer_key']}&access_token=#{PocketAPI.sharedAPI.pkt_getToken}" \
        "&since=#{since_time}&detailType=complete"
      end

    AFMotion::JSON.get(url.url_encode) do |result|
      items = []
      error_message = nil
      begin
        if result.success?
          if !result.object['list'].empty?
            fetched_data = result.object['list'].values.sort{|a, b| a['sort_id'] <=> b['sort_id'] }

            # status = 0（unread）のitemのみ取得
            items = fetched_data.select{|data| data['status'].to_i == 0 }.map{|data| self.new(data) }
          end
        elsif result.failure?
          error_message = result.error.localizedDescription
        else
          error_message = 'エラーが発生しました'
        end
      rescue => e
        error_message = e
      end
      block.call(items, error_message)
    end
  end

  def getBookmarkCount(&block)
    AFMotion::HTTP.get("http://api.b.st-hatena.com/entry.count?url=#{self.url.url_encode}") do |result|
      bookmark_count = nil
      error_message = nil
      begin
        if result.success?
          bookmark_count = result.body.to_i
          self.bookmark_count = bookmark_count
        elsif result.failure?
          error_message = result.error.localizedDescription
        else
          error_message = "エラーが発生しました"
        end
      rescue => e
        error_message = e
      end
      block.call(bookmark_count, error_message)
    end
  end

  def archive(&block)
    archive_request_array = [
      {
        "action" => "archive",
        "item_id" => self.id
      }
    ]
    archive_request_json = NSJSONSerialization.dataWithJSONObject(
      archive_request_array,
      options: NSJSONWritingPrettyPrinted,
      error: nil
    )
    url = "#{BASE_URL}send?consumer_key=#{MY_ENV['pocket']['consumer_key']}&access_token=#{PocketAPI.sharedAPI.pkt_getToken}" \
      "&actions=#{archive_request_json}"

    AFMotion::JSON.get(url.url_encode) do |result|
      response = false
      error_message = nil
      begin
        if result.success?
          response = true
        elsif result.failure?
          error_message = result.error.localizedDescription
        else
          error_message = "エラーが発生しました"
        end
      rescue => e
        error_message = e
      end
      block.call response, error_message
    end
  end
end
