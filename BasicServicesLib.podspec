#
#  Be sure to run `pod spec lint BasicServicesLib.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "BasicServicesLib"
  s.version      = "1.0.0"
  s.summary      = "The basic service component of the project."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
  The basic service component of the project
		   DESC

  s.homepage     = "https://github.com/qiancaox/BasicServicesLib.git"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  # s.license      = "MIT (example)"
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

  s.author             = { "qiancaox" => "qiancaoxiang@gmail.com" }
  # Or just: s.author    = "qiancaox"
  # s.authors            = { "qiancaox" => "" }
  # s.social_media_url   = "http://twitter.com/qiancaox"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
  s.platform     = :ios, "8.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/qiancaox/BasicServicesLib.git", :tag => s.version }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.public_header_files = "BasicServicesLib/BasicServicesLib.h"
  s.source_files  = "BasicServicesLib/BasicServicesLib.h"

  s.subspec 'AppBase' do |ss|
  	ss.source_files = 'BasicServicesLib/AppBase/*.{h,m}'
  	ss.public_header_files = 'BasicServicesLib/AppBase/*.h'
  	ss.frameworks = 'UIKit'
  end

  s.subspec 'Categroies' do |ss|

		ss.subspec 'UIButton' do |sss|
      			sss.source_files = 'BasicServicesLib/Categroies/UIButton+*.{h,m}'
      			sss.public_header_files = 'BasicServicesLib/Categroies/UIButton+*.h'
		end

		ss.subspec 'UITextField' do |sss|
      			sss.source_files = 'BasicServicesLib/Categroies/UITextField+*.{h,m}'
      			sss.public_header_files = 'BasicServicesLib/Categroies/UITextField+*.h'
		end

		ss.subspec 'UIAlertController' do |sss|
      			sss.source_files = 'BasicServicesLib/Categroies/UIAlertController+*.{h,m}'
      			sss.public_header_files = 'BasicServicesLib/Categroies/UIAlertController+*.h'
		end

		ss.subspec 'UIWindow' do |sss|
      			sss.source_files = 'BasicServicesLib/Categroies/UIWindow+*.{h,m}'
      			sss.public_header_files = 'BasicServicesLib/Categroies/UIWindow+*.h'
		end

		ss.subspec 'UIImage' do |sss|
      			sss.source_files = 'BasicServicesLib/Categroies/UIImage+*.{h,m}'
      			sss.public_header_files = 'BasicServicesLib/Categroies/UIImage+*.h'
		end

		ss.subspec 'UIView' do |sss|
      			sss.source_files = 'BasicServicesLib/Categroies/UIView+*.{h,m}'
      			sss.public_header_files = 'BasicServicesLib/Categroies/UIView+*.{h,m}'
		end

		ss.subspec 'NSString' do |sss|
      			sss.source_files = 'BasicServicesLib/Categroies/NSString+*.{h,m}'
      			sss.public_header_files = 'BasicServicesLib/Categroies/NSString+*.h'
		end

		ss.subspec 'NSData' do |sss|
      			sss.source_files = 'BasicServicesLib/Categroies/NSData+*.{h,m}'
      			sss.public_header_files = 'BasicServicesLib/Categroies/NSData+*.h'
		end

		ss.subspec 'NSDictionary' do |sss|
      			sss.source_files = 'BasicServicesLib/Categroies/NSDictionary+*.{h,m}'
      			sss.public_header_files = 'BasicServicesLib/Categroies/NSDictionary+*.h'
		end

  end

  s.subspec 'UIKit' do |ss|

		ss.subspec 'UIPlaceholderTextView' do |sss|
      			sss.source_files = 'BasicServicesLib/UIKit/UIPlaceholderTextView.{h,m}'
      			sss.public_header_files = 'BasicServicesLib/UIKit/UIPlaceholderTextView.h'
		end

		ss.subspec 'UIRelayoutButton' do |sss|
      			sss.source_files = 'BasicServicesLib/UIKit/UIRelayoutButton.{h,m}'
      			sss.public_header_files = 'BasicServicesLib/UIKit/UIRelayoutButton.h'
		end

		ss.subspec 'PresentedHUDBasicViewController' do |sss|
      			sss.source_files = 'BasicServicesLib/UIKit/PresentedHUDBasicViewController.{h,m}'
      			sss.public_header_files = 'BasicServicesLib/CUIKit/PresentedHUDBasicViewController.h'
		end

		ss.subspec 'NoDatasourceView' do |sss|
      			sss.source_files = 'BasicServicesLib/UIKit/NoDatasourceView.{h,m}', 'BasicServicesLib/UIKit/UIView+NoDatasource.{h,m}'
      			sss.public_header_files = 'BasicServicesLib/UIKit/NoDatasourceView.h', 'BasicServicesLib/UIKit/UIView+NoDatasource.h'
		end

  end

  s.subspec 'Utils' do |ss|
  	ss.source_files = 'BasicServicesLib/Utils/*.{h,m}'
  	ss.public_header_files = 'BasicServicesLib/Utils/*.h'
  end

  s.subspec 'Networking' do |ss|
  	ss.source_files = 'BasicServicesLib/Networking/*.{h,m}'
  	ss.public_header_files = 'BasicServicesLib/Networking/*.h'
  end

  s.subspec 'Privates' do |ss|
  	ss.source_files = 'BasicServicesLib/Privates/*.{h,m}'
  	ss.public_header_files = 'BasicServicesLib/Privates/*.h'
  end

  s.subspec 'Database' do |ss|
  	ss.source_files = 'BasicServicesLib/Database/*.{h,m}'
  	ss.public_header_files = 'BasicServicesLib/Database/*.h'
  end


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  s.resource  = "BasicServicesLib/BasicServicesLib.bundle"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "AFNetworking", "~> 3.2.1"
  s.dependency "FMDB", "~> 2.7.5"
  s.dependency "MBProgressHUD", "~> 1.1.0"

end
