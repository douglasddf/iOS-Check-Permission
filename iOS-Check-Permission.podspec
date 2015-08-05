#
# Be sure to run `pod lib lint iOS-Check-Permission.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "iOS-Check-Permission"
  s.version          = "0.1.0"
  s.summary          = "Permits the user request for permission access the iOS (Calendar , Reminder, Gallery and Location)"
  s.description      = <<-DESC
**iOS Check Permissions**

Offer a set of methods to solicit the use of operating system resources (iOS),
through the permissions to authorize the use of resources such as:

- Camera
- Gallery
- Reminder
- Location

See more on Youtube video:

- https://www.youtube.com/watch?v=JxdlaEp6dC0
DESC
  s.homepage         = "https://github.com/douglasddf/iOS-Check-Permission"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Douglas Frari" => "douglas.frari@gmail.com" }
  s.source           = { :git => "https://github.com/douglasddf/iOS-Check-Permission.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/douglasddf'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'iOSCheckPermission' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'CoreLocation', 'AVFoundation','AssetsLibrary','EventKit','Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
end
