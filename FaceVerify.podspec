
Pod::Spec.new do |s|
  s.name             = 'FaceVerify'
  s.version          = '0.1.0'
  s.summary          = 'Library for face recognition using eigenfaces'
 
  s.description      = <<-DESC
Library for face recognition using eigenfaces
                       DESC
 
  s.homepage         = 'https://github.com/Arman1997/FaceVerify'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Arman Galstyan' => 'armangalstyan9597@gmail.com' }
  s.source           = { :git => 'https://github.com/Arman1997/FaceVerify.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '11.0'
  s.source_files = 'FaceTrain/*.swift'
 
end