Pod::Spec.new do |s|

s.name         = 'AliYunOSSManager'
s.version      = '0.0.1'
s.summary      = 'A simple manager class for AliYunOSS'
s.homepage     = 'https://github.com/liukunpengiOS/AliYunOSSManager'
s.license      = 'MIT'
s.author       = { 'kunpeng' => '1169405067@qq.com'}
s.platform     = :ios, "8.0"
s.source       = { :git => 'https://github.com/liukunpengiOS/AliYunOSSManager.git', :tag => s.version }
s.source_files = 'AliYunOSSManager/**/*.swift'
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
s.requires_arc = true
s.dependency 'AliyunOSSiOS', '~> 2.6.0'
end
