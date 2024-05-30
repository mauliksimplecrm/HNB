# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'HNB' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for HNB
  pod 'ProgressHUD'
  pod 'SAMKeychain'
  
  # pod 'LaraCrypt'
  pod 'CryptoSwift'
  
  
  
  target 'HNBTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'HNBUITests' do
    # Pods for testing
  end
  
end


post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.1'
      end
    end
  end
end
