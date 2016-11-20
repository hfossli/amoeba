Pod::Spec.new do |s|
    s.name         = "amoeba"
    s.version      = "0.1"
    s.summary      = "Cassowary constraint solver"
    s.homepage     = "https://github.com/hfossli/amoeba"
    s.license      = 'MIT'
    s.platform      = :ios, '8.0'
    s.requires_arc  = true
    s.authors      = {
      "Xavier Wang" => "weasley.wx@gmail.com",
    	"Håvard Fossli" => "hfossli@gmail.com",
    	}
    s.source       = {
        :git => "https://github.com/hfossli/amoeba.git",
        :tag => s.version.to_s
        }

    s.ios.deployment_target = '8.0'
    s.osx.deployment_target = '10.8'

    s.source_files  = [
      'amoeba.h',
      'Swift/Source/**/*',
    ]
end
