#platform :ios, '7.0'
#use_frameworks!
#pod 'AVOSCloudDynamic'
# 如果使用实时通信功能，可以添加：
#pod 'AVOSCloudIMDynamic'
# 如果使用崩溃收集功能，可以添加：
#pod 'AVOSCloudCrashReportingDynamic'
#pod 'React'
#pod 'React/RCTText'
# Depending on how your project is organized, your node_modules directory may be
# somewhere else; tell CocoaPods where you've installed react-native from npm

def shared_pods
#pod 'React', :path => '/Users/yaoandw/Documents/ios/react/react-native', :subspecs => [
#  'Core',
#  'RCTImage',
#  'RCTNetwork',
#  'RCTText',
#  'RCTWebSocket',
  # Add any other subspecs you want to use in your project
#]
pod "AFNetworking", "~> 2.0"
pod 'EGYWebViewController'
pod 'SVProgressHUD'
pod 'AVOSCloud'
pod 'AVOSCloudCrashReporting'
pod 'AVOSCloudIM'
pod 'LeanCloudSocial'
pod 'MCFireworksButton'
pod "MWPhotoBrowser"
#pod 'MMDrawerController', '~> 0.5.7'
pod 'MJRefresh'
pod 'LGSideMenuController', '~> 1.0.0'
pod 'Bugly'
end

target "joke" do
    shared_pods
end
