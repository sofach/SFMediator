
Pod::Spec.new do |s|

  s.name         = "SFMediator"
  s.version      = "1.0.1"
  s.summary      = "mediator"

  s.description  = <<-DESC
                    mediator for module
                   DESC

  s.homepage     = "https://github.com/sofach/SFMediator"

  s.license      = "MIT"

  s.author       = { "sofach" => "sofach@126.com" }

  s.platform     = :ios
  s.platform     = :ios, "5.0"

  s.source       = { :git => "https://github.com/sofach/SFMediator.git", :tag => "1.0.1" }


  s.source_files  = "SFMediator/lib/**/*.{h,m}"
  s.requires_arc = true

end
