# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'VotingAdminEZV' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for VotingAdminEZV

 pod 'Alamofire', '~> 4.7'

 pod 'RxSwift', '~> 5'
 pod 'RxCocoa', '~> 5'

 #https://github.com/evgenyneu/keychain-swift
 pod 'KeychainSwift', '~> 13.0'
 
end
post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
               end
          end
   end
end