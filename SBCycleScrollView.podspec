

Pod::Spec.new do |s|

  s.name         = "SBCycleScrollView"
  s.version      = "0.0.5"
  s.summary      = "功能强大的图片、文字轮播器 by swift"
  s.description  = <<-DESC
			功能强大的图片、文字轮播器,支持纯文字、网络图片、本地图片、图片加文字以及各种圆点样式
		      DESC
  s.homepage     = "https://github.com/xumaohuai/SBCycleScrollView"
  s.license          = "Copyright (c) 2018 maohuaiXu"
  s.author       = { "徐老茂" => "xmh_iOS@126.com"}
  s.platform     = :ios, "9.0"
  s.source        = { :git => "https://github.com/xumaohuai/SBCycleScrollView.git", :tag => "0.0.5"}
  s.source_files = "SBCycleScrollView","SBCycleScrollView/**/*.{swift}"
  s.dependency 'Kingfisher', '~> 4.8.0'
  s.requires_arc = true	 
  s.swift_version = '4.0'

end
