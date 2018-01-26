Pod::Spec.new do |s|

  s.name         = "FavoriteButton"
  s.version      = "3.0.1"
  s.summary      = "Twitter's heart like animated button updated to Swift 4"
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/MauriceArikoglu/FavoriteButton.git'
  s.author       = { 'Maurice Arikoglu' => 'development@mauricearikoglu.de' }
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/MauriceArikoglu/FavoriteButton.git', :tag => s.version.to_s }
  s.source_files  = 'Source/**/*.swift'
  s.requires_arc = true
  end

