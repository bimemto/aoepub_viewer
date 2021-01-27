#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint aoepub_viewer.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'aoepub_viewer'
  s.version          = '0.0.1'
  s.summary          = 'A epub viewer flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/bimemto/aoepub_viewer.git'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'DuyNK' => 'duydkny@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.resources = [
    'Assets/Resources/*.{js,css}',
    'Assets/Resources/*.xcassets',
    'Assets/Resources/Fonts/**/*.{otf,ttf}'
  ]
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  
  s.libraries  = "z"
  s.dependency 'SSZipArchive', '2.2.3'
  s.dependency 'MenuItemKit', '4.0.1'
  s.dependency 'ZFDragableModalTransition', '0.6'
  s.dependency 'AEXML', '4.6.0'
  s.dependency 'FontBlaster', '5.1.1'
  s.dependency 'RealmSwift', '10.5.0'
  
  s.ios.deployment_target = '9.0'
end
