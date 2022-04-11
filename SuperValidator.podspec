Pod::Spec.new do |s|
  s.name             = 'SuperValidator'
  s.version          = '0.1.0'
  s.summary          = 'A short description of SuperValidator.'

  s.homepage         = 'https://github.com/tokopedia/ios-supervalidator'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Tokopedia' => 'nakama@tokopedia.com' }
  s.source           = { :git => 'https://github.com/tokopedia/ios-supervalidator.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '4.0'

  s.source_files = 'Sources/SuperValidator/**/*'
end
