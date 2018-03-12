platform :ios, '10.3'

use_frameworks!
inhibit_all_warnings!

workspace 'UIDS.xcworkspace'

target 'UIDS' do

  pod 'DZNEmptyDataSet'
  pod 'ChameleonFramework'
  pod 'MagicalRecord'
  #pod 'iRate'
  pod 'Then'
  
  pod 'HandyJSON'
  pod 'SwiftyJSON'
  pod 'Dodo'
  pod 'SDWebImage'
  pod 'PermissionScope'#汉化
  pod 'Alamofire'
  pod 'Reachability'
  
  
  #ui
  pod 'TYPagerController'
  pod 'SVProgressHUD'
  pod 'PKRevealController'
  pod 'RETableViewManager'
  pod 'Font-Awesome-Swift'
  pod 'ESPullToRefresh'
  pod 'IQKeyboardManagerSwift'#键盘
  pod 'SnapKit'
  pod 'TextFieldEffects'
  pod 'KMPlaceholderTextView'
  #    pod 'MLeaksFinder'              # 检测内存泄漏
  pod 'LPDQuoteImagesView'
  pod 'ReusableKit'
  pod 'SwiftForms'
  
  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'NSObject+Rx'
  pod 'RxGesture'
  pod 'RxDataSources'
  
  
  #授权
  #pod 'Weibo_SDK', :git => 'https://github.com/sinaweibosdk/weibo_ios_sdk.git'
  # pod 'WechatOpenSDK'
#  pod 'zhPopupController'

#骑牛上传
  pod 'Qiniu'
  
  #protobuf
  pod 'SwiftProtobuf'
  #webscoket
  pod 'Starscream'
  
  #IM JPUSH
  pod 'JMessage'
  pod 'YHPopupView'
  pod 'YHPhotoKit'
  pod 'MBProgressHUD'
  pod 'MJRefresh'
  
end


post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        if target.name == 'SnapKit' || target.name == 'Font-Awesome-Swift' || target.name == 'SwiftForms'

        else
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end

