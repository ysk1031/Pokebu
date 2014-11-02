class Setting
  attr_accessor :title

  SETTING_INFOS = [
    %w(はてなブックマーク hoge),
    %w(このアプリについて fuga)
  ]

  def initialize(info)
    @title = info[:title]
    @action = info[:action]
  end

  def self.initialize_in_bulk
    settings = []
    SETTING_INFOS.each do |info|
      setting_info = { title: info[0], action: info[1] }
      settings << self.new(setting_info)
    end

    settings
  end
end
