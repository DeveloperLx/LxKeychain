Pod::Spec.new do |s|
  s.name         = "LxKeychain"
  s.version      = "1.0.0"
  s.summary      = "Manage your username and password for iOS and OS X platform. Highly encryption and won't be lose even you uninstall your app."

  s.homepage     = "https://github.com/DeveloperLx/LxKeychain"
  s.license      = 'Apache'
  s.authors      = { 'DeveloperLx' => 'developerlx@yeah.com' }
  s.platform     = :ios, "6.0"
  s.ios.deployment_target = "6.0"
  s.source       = { :git => "https://github.com/DeveloperLx/LxKeychain.git", :tag => s.version}
  s.source_files = 'LxKeychain/LxKeychain.*'
  s.requires_arc = true
  s.frameworks   = 'Foundation', 'CoreGraphics', 'CommonCrypto', 'Security', 'UIKit'
end
