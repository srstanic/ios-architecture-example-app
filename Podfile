source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '14.2'

target 'MobileShop' do
  use_frameworks!
  pod 'Firebase/Analytics'
  pod 'FBSDKCoreKit/Swift'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
  end
end
