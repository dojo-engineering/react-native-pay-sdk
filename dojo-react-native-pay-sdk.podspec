require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))
folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'

Pod::Spec.new do |s|
  s.name         = "dojo-react-native-pay-sdk"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "11.0" }
  s.source       = { :git => "https://github.com/dojo-engineering/react-native-pay-sdk.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm}"

  s.compiler_flags = '-fmodules -fcxx-modules' # Enable C++ compiler for modules

  s.dependency "React-Core"

  # Dojo iOS SDK Dependencies
  s.dependency 'dojo-ios-sdk-drop-in-ui', '1.4.4'
  s.dependency 'dojo-ios-sdk', '1.4.2'

  # Don't install the dependencies when we run `pod install` in the old architecture.
  if ENV['RCT_NEW_ARCH_ENABLED'] == "1" then
    install_modules_dependencies(s)
  else
    s.dependency   "React-Core"
  end
end
