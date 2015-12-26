
Pod::Spec.new do |s|

  s.name         = "SwiftBanner"
  s.version      = "1.0.0"
  s.summary      = "A Cycle Banner by Swift"
  s.description  = <<-DESC
                    It is a banner view used on iOS, which implement by Swift.
                   DESC
  s.homepage     = "https://github.com/tinyxx/SwiftBanner"
  s.license      = "MIT"
  s.author       = { "tinyxx" => "tinyxx415@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/tinyxx/SwiftBanner.git", :tag => "1.0.0" }
  s.source_files  = "SwiftBanner/*"
  s.frameworks = "UIKit"

end
