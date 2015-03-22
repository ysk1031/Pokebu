class Bookmark
  attr_accessor :comment, :user_name, :user_image, :timestamp

  class << self
    def fetch_bookmarks(entry_url, &block)
      url = "http://b.hatena.ne.jp/entry/jsonlite/?url=#{entry_url}".url_encode

      AFMotion::JSON.get(url) do |result|
        bookmarks = []
        error_message = nil
        begin
          if result.success?
            # 全件表示
            # result.object["bookmarks"].each{|data| bookmarks << self.new(data) }

            # コメント付きのみ表示
            result.object["bookmarks"].each{|data| bookmarks << self.new(data) unless data["comment"].empty? }
          elsif result.failure?
            error_message = result.error.localizedDescription
          else
            error_message = 'エラーが発生しました'
          end
        rescue => e
          error_message = e
        end
        block.call(bookmarks, error_message)
      end
    end
  end

  def initialize(data)
    @comment = data["comment"]
    @user_name = data["user"]
    @user_image = "http://cdn1.www.st-hatena.com/users/#{data["user"][0..1]}/#{data["user"]}/profile.gif"
    @timestamp = data["timestamp"]
  end

  def added_time
    time_format_array = []
    @timestamp.split(' ').each_with_index do |time_data, index|
      time_elements = index == 0 ? time_data.split('/') : time_data.split(':')
      time_elements.each{|d| time_format_array << d }
    end
    time = Time.local(
      time_format_array[0], time_format_array[1], time_format_array[2],
      time_format_array[3], time_format_array[4], time_format_array[5]
    )

    # time.timeAgo
    time.strftime("%Y/%m/%d")
  end
end