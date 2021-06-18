#
# Be sure to run `pod lib lint UUDeviceModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UUDeviceTest'
  s.version          = '1.0.0'
  s.summary          = 'A short description of UUDeviceModule.'


  s.description      = <<-DESC
  Fix SwiftyPing
                       DESC

  s.homepage         = 'https://github.com/BecomerichAsun/UUDeviceTest'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'becomerichios@163.com' => 'becomerichios@163.com' }
  s.source           = { :git => 'https://github.com/BecomerichAsun/UUDeviceTest.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
  s.source_files = 'UUDeviceTest/Classes'
  s.resources = 'UUDeviceTest/UUCheckSources.bundle'
  s.framework = 'UIKit', 'AVFoundation'
  s.dependency 'SnapKit','~> 5.0.0'
  s.dependency 'SVGAPlayer', '2.3.5'
  
end
