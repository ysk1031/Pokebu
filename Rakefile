# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

require 'rubygems'
require 'motion-cocoapods'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Pokebu'
  app.version = '1.0'
  app.short_version = '1.0'
  app.deployment_target = '7.0'

  app.my_env.file = './config/environment.yml'

  app.pods do
    pod 'AFNetworking'
    pod 'TTTAttributedLabel'
    pod 'NSDate+TimeAgo'
    pod 'HatenaBookmarkSDK', git: 'git@github.com:hatena/Hatena-Bookmark-iOS-SDK.git',
      branch: 'prefixed-afnetworking'
  end
end
