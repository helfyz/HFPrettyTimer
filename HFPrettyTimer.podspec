#
#  Be sure to run `pod spec lint HFPrettyTimer.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "HFPrettyTimer"
  s.version      = "0.1.0"
  s.summary      = "NSTimmer强引用 自动化处理"
  s.description  = <<-DESC
        NSTimmer强引用 自动化处理
                   DESC
  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.requires_arc          = true
  s.homepage    = "https://github.com/helfyz/HFPrettyTimer"
  s.license     = "MIT"
  s.author      = { "helfy" => "562812743@qq.com" }
  s.source              = { :git => "git@github.com:helfyz/HFPrettyTimer.git", :tag => "#{s.version}" }
  s.source_files        = "HFPrettyTimer", "HFPrettyTimer/**/*.{h,m}"
  s.public_header_files = "HFPrettyTimer/**/*.h"
end
