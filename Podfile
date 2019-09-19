platform :ios, '11.0'

target 'H19MediaViewer' do

  use_frameworks!

  pod 'SDWebImage'

  target 'H19MediaViewerTests' do
      pod 'Nimble'
      pod 'Quick'
  end

  target 'H19MediaViewerSandbox' do
  end

end

# Hooks

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '5.0'
        end
    end
end
