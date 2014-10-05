class PocketItem
  attr_accessor :sort_id, :title, :url

  BASE_URL = 'https://getpocket.com/v3/get'

  def initialize(data)
    @sort_id = data['sort_id']
    @title = data['resolved_title'].empty? ? data['given_title'] : data['resolved_title']
    @url = data['resolved_url']
  end


  def self.fetch_items(fetch_count, offset, &block)
    url = "#{BASE_URL}?consumer_key=#{ENV['POCKET_CONSUMER_KEY']}&access_token=#{ENV['POCKET_ACCESS_TOKEN']}" \
      "&count=#{fetch_count}&offset=#{offset}&sort=newest"

    AFMotion::JSON.get(url) do |result|
      items = []
      error_message = nil

      begin
        if result.success?
          fetched_data = result.object['list'].values.sort{|a, b| a['sort_id'] <=> b['sort_id'] }
          items = fetched_data.map{|data| PocketItem.new(data) }
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
