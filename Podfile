platform :ios, '8.0'
use_frameworks!

link_with 'app-watchos', 'app-watchos Extension'

def shared_pods
	pod 'Alamofire', '~> 3.2.1'
	pod 'Money'
	pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'		
end

target 'app-ios' do
	platform :ios, '8.0'
	shared_pods
	pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
	pod 'CardIO'
	pod 'Stripe'
	pod 'plaid-ios-sdk'
	pod 'plaid-ios-link'
	pod 'TextFieldEffects'
	pod 'UIColor_Hex_Swift'
	pod 'KeychainSwift'
	pod 'MZFormSheetPresentationController'
	pod 'PasscodeLock'
	pod 'BEMCheckBox'
	pod 'BEMSimpleLineGraph'
	pod 'CWStatusBarNotification'
	pod 'SnapKit'
	pod 'Gecco'
	pod 'DZNEmptyDataSet'
	pod 'Former'
	pod 'KMPlaceholderTextView'
	pod 'SFDraggableDialogView'
	pod 'UICountingLabel'
	pod 'AnimatedSegmentSwitch'
	pod 'JGProgressHUD'	
	pod 'MCSwipeTableViewCell'
	pod 'JVFloatLabeledTextField'
	pod 'JSSAlertView'
	pod 'CountryPicker'
	pod 'FlagKit'
	pod 'DGElasticPullToRefresh'
	pod 'QRCode'
	pod 'XLActionController'
	pod 'AYVibrantButton'
	pod 'GaugeKit'
	pod 'StepSlider'
	pod 'ImagePicker'
	pod 'DKCircleButton'
	pod 'TransitionTreasury'
	pod 'TransitionAnimation'
	pod 'LTMorphingLabel'
	pod 'PermissionScope'
	pod 'CellAnimator'
	pod '1PasswordExtension'
	pod 'Armchair'
	pod 'AvePurchaseButton'
	pod 'EmitterKit'
	pod 'DynamicColor'
	pod 'M13Checkbox'
	pod 'BTNavigationDropdownMenu'
	pod 'VMaskTextField'
	pod 'Shimmer'
	pod 'UIScrollView-InfiniteScroll'

	# Fabric
	pod 'Fabric'
	pod 'Crashlytics'

	# Uninstalled
	#pod 'HanekeSwift'
	#pod 'DOFavoriteButton'

	post_install do |installer|
    	`find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
    end
end

target 'app-iosTests' do

end

target 'app-iosUITests' do

end

target 'app-watchos' do
  platform :watchos, '2.0'
end

target 'app-watchos Extension' do
  platform :watchos, '2.0'
  shared_pods
end


