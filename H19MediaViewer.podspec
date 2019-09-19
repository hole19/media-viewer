#
#  Be sure to run `pod spec lint H19MediaViewer.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "H19MediaViewer"
  s.version      = "1.1.2"
  s.summary      = "A simple and customizable media viewer."
  s.description  = <<-DESC
  A simple and customizable media viewer with pagination.
                   DESC

  s.homepage     = "https://github.com/hole19/media-viewer"

  s.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.authors = { "H19 Team" => "dev.ios@hole19golf.com" }
  s.source = { :git => "https://github.com/hole19/media-viewer.git", :tag => "#{s.version}" }

  s.platform      = :ios, "8.0"
  s.swift_version =  '5.0'
  s.dependency "SDWebImage"

  s.source_files  = "H19MediaViewer"
  s.exclude_files = "H19MediaViewerTests"
end
