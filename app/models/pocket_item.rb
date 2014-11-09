class PocketItem
  attr_accessor :id, :title, :url, :excerpt, :timestamp

  BASE_URL = 'https://getpocket.com/v3/get'

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
    @timestamp = data['time_added'].to_i
  end

  def added_time
    Time.at(@timestamp).timeAgo
  end


  def self.fetch_items(fetch_count, offset, since_time = nil, &block)
    url =
      if since_time.nil?
        "#{BASE_URL}?consumer_key=#{ENV['POCKET_CONSUMER_KEY']}&access_token=#{ENV['POCKET_ACCESS_TOKEN']}" \
        "&count=#{fetch_count}&offset=#{offset}&sort=newest"
      else
        "#{BASE_URL}?consumer_key=#{ENV['POCKET_CONSUMER_KEY']}&access_token=#{ENV['POCKET_ACCESS_TOKEN']}" \
        "&since=#{since_time}&sort=newest"
      end

    AFMotion::JSON.get(url) do |result|
      items = []
      error_message = nil

      begin
        if result.success?
          if !result.object['list'].empty?
            fetched_data = result.object['list'].values.sort{|a, b| a['sort_id'] <=> b['sort_id'] }
            items = fetched_data.map{|data| self.new(data) }
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
end
