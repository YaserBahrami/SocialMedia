# Uncomment this line to define a global platform for your project
# platform :ios, ‘8.0’

target 'SocialMedia' do
    # Comment this line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    pod 'Firebase', '~> 2.3.3'
    
    pod 'Alamofire'
    
    pod 'FBSDKLoginKit'
    pod 'FBSDKCoreKit'
    
end


### Alamofire error

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
