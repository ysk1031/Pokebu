class Setting
  attr_accessor :title, :action

  SETTING_SECTIONS = [
    [
      { title: "Pocketアカウント", action: "pocket" },
      { title: "はてなブックマークアカウント", action: "hatena" }
    ],
    [
      { title: "このアプリについて", action: "app_info" }
    ]
  ]

  def initialize(info)
    @title  = info[:title]
    @action = info[:action]
  end

  def self.initialize_in_bulk
    settings = []
    SETTING_SECTIONS.each_with_index do |section, index|
      settings[index] = []
      section.each do |attr|
        settings[index] << self.new(attr)
      end
    end

    settings
  end
end
