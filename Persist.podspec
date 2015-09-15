Pod::Spec.new do |s|
  s.name                       = "Persist"
  s.version                    = "2.0.0"
  s.summary                    = "A simple Swift 2.0 Core Data stack using parent/child contexts"
  s.description                = <<-DESC
                                 Persist is a simple, reusable Core Data stack written in Swift.
                                 It also provides some lightweight helpers for common actions such as creating entities, and querying.
                                 It supports iOS 8+, watchOS 2.0, and Mac OS 10.9+.
                                 DESC
  s.homepage                   = "https://github.com/endocrimes/Persist"
  s.license                    = { :type => "MIT", :file => "LICENSE" }
  s.author                     = { "Danielle Lancashire" => "Dan@Tomlinson.io" }
  s.social_media_url           = "http://twitter.com/endocrimes"
  s.ios.deployment_target      = "8.0"
  s.osx.deployment_target      = "10.9"
  s.watchos.deployment_target  = "2.0"
  s.source                     = { 
                                    :git => "https://github.com/endocrimes/Persist.git",
                                    :tag => s.version
                                 }
  s.source_files               = "Classes", "Persist/*.{h,swift}"
  s.framework                  = "CoreData"
  s.documentation_url          = "https://endocrimes.github.io/Persist"
end
