source 'https://github.com/CocoaPods/Specs.git'

# Uncomment the next line to define a global platform for your project
# platform :macos, '9.0'

post_install do |installer|
  installer.aggregate_targets.each do |target|
    target.xcconfigs.each do |variant, xcconfig|
      xcconfig_path = target.client_root + target.xcconfig_relative_path(variant)
      IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
    end
  end
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.base_configuration_reference.is_a? Xcodeproj::Project::Object::PBXFileReference
        xcconfig_path = config.base_configuration_reference.real_path
        IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
      end
    end
  end
  installer.generated_projects.each do |project|
    project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '11.0'
         end
    end
  end
end
def commonlibs
  pod 'AFNetworking'
  pod 'Masonry'
  pod 'SDWebImage'
  pod 'PermissionsKit-macOS'
  pod 'GCDWebServer'
end

target 'HqMacTools' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  commonlibs
  # Pods for HqMacTools

  target 'HqMacToolsTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'HqMacToolsUITests' do
    # Pods for testing
  end

end
