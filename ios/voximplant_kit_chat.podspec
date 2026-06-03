#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint voximplant_kit_chat.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'voximplant_kit_chat'
  s.version          = '1.1.0'
  s.summary          = 'Voximplant Kit Chat'
  s.description      = <<-DESC
Voximplant Kit Chat
                       DESC
  s.homepage         = 'http://voximplant.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Voximplant' => 'mobiledev@zingaya.com' }
  s.source           = { :path => '.' }
  s.source_files = 'voximplant_kit_chat/Sources/voximplant_kit_chat/**/*.swift'
  s.resource_bundles = {'plugin_name_privacy' => ['voximplant_kit_chat/Sources/voximplant_kit_chat/PrivacyInfo.xcprivacy']}
  s.dependency 'Flutter'
  s.dependency 'VoximplantKitChatUI', '1.6.1'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.9'
end
