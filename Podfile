platform :ios, '8.0'
use_frameworks!

link_with 'app-watchos', 'app-watchos Extension'

def shared_pods
	pod 'Alamofire', '~> 3.2.1'
	pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'	
#	pod 'AlamoArgo', '~> 0.5.3'	
#	pod 'Argo', '~> 2.2.0'	
end

target 'protonpay-ios' do
	platform :ios, '8.0'
	shared_pods
	pod 'RESideMenu'
	pod 'Runes'
	pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
	pod 'CardIO'
	pod 'Stripe'
	pod 'VideoSplashKit'
	pod 'TextFieldEffects'
	pod 'UIColor_Hex_Swift'
	pod 'KeychainSwift'
	pod 'MZFormSheetPresentationController'
	pod 'PasscodeLock'
	pod 'BEMCheckBox'
	pod 'SwiftGifOrigin'
	pod 'CWStatusBarNotification'
	pod 'Koloda'
	pod 'SnapKit'
	pod 'Gecco'
	pod 'VENCalculatorInputView'
	pod 'RAMAnimatedTabBarController'
	pod 'RAMReel'
	pod 'DZNEmptyDataSet'
	pod 'IOStickyHeader'
	pod 'AMViralSwitch'
	pod 'Former'
	pod 'KMPlaceholderTextView'
	pod 'SIAlertView'
	pod 'DCPathButton'
	pod 'SFDraggableDialogView'
	pod 'UICountingLabel'
	pod 'DGRunkeeperSwitch'
	pod 'JGProgressHUD'	
	#pod 'DOFavoriteButton'

	post_install do |installer|
    	`find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
    end
end

target 'protonpay-iosTests' do

end

target 'protonpay-iosUITests' do

end

target 'app-watchos' do
  platform :watchos, '2.0'
end

target 'app-watchos Extension' do
  platform :watchos, '2.0'
  shared_pods
end


