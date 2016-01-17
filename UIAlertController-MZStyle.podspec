Pod::Spec.new do |s|
  s.name     = 'UIAlertController-MZStyle'
  s.version  = '1.0.0'
  s.platform = :ios, '8.0'
  s.license  = 'MIT'
  s.summary  = 'Category for UIAlertController customization.'
  s.homepage = 'http://inspace.io'
  s.authors  = 'Michał Zaborowski'
  s.source   = { :git => 'https://github.com/m1entus/UIAlertController-MZStyle.git', :tag => '1.0.0' }
  s.source_files = ['UIAlertController-MZStyle/*.{h,m}']
  s.requires_arc = true

end
