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
  app.name = 'PokeBu'
  app.version = '1.0'
  app.short_version = '1.0'
  app.deployment_target = '7.0'
  app.identifier = 'io.github.ysk1031.Pokebu'

  app.development do
    app.provisioning_profile = "/Users/Yusuke/ios-dev/PokebuDev.mobileprovision"
    app.codesign_certificate = "iPhone Developer: YUSUKE AONO (E9UARVFJU9)"
    app.entitlements['keychain-access-groups'] = [
      app.seed_id + '.' + app.identifier
    ]
  end

  app.my_env.file = './config/environment.yml'

  app.info_plist['CFBundleURLTypes'] = [
    { 'CFBundleURLName' => 'com.readitlater',
      'CFBundleURLSchemes' => ['pocketapp32674']
    }
  ]
  app.info_plist['UILaunchStoryboardName'] = 'Launch Screen'

  app.pods do
    pod 'AFNetworking'
    pod 'TTTAttributedLabel'
    pod 'HatenaBookmarkSDK', git: 'git@github.com:hatena/Hatena-Bookmark-iOS-SDK.git'
    pod 'PocketAPI', git: 'git@github.com:ysk1031/Pocket-ObjC-SDK.git',
      branch: 'cocoapods-dependency'
  end
end
