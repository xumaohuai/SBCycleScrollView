# SBCycleScrollView
## ☆☆☆ “功能强大的图片、文字轮播器,支持纯文字、网络图片、本地图片、图片加文字以及各种圆点样式” ☆☆☆
![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Swift-orange.svg)
![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg)
### 支持pod导入
pod 'SBCycleScrollView','~> 0.0.4'


#### SBCycleScrollView是一个简单好用的图片轮播器,支持网络图片,本地图片,文字,滑动方向,storyboard以及各种样式.
[Github地址,欢迎star😆](https://github.com/xumaohuai/SBCycleScrollView)
### 使用方式
使用cocoapods导入,pod 'SBCycleScrollView','~>0.0.4',如果发现pod search SBCycleScrollView 搜索出来的不是最新版本，请先执行pod setup指令,获取最新数据源就可以了.
### 提供三种初始化方式
```
通过网络图片地址初始化
let cycleScrollView = CycleScrollView.initScrollView(frame: frame, imageNamesGroup: imageUrls, cycleOption: CycleOption())
```
```
通过本地图片名称或地址初始化
let cycleScrollView = CycleScrollView.initScrollView(frame: frame, imageNamesGroup: localImages, cycleOptions: CycleOptions())
```
```
通过文字数组初始化
let cycleScrollView = CycleScrollView.initScrollView(frame: frame, titleGroup: titles, cycleOption: CycleOption())
```
```
推荐方式,通过代理和占位图初始化,常用于图片异步获取的时候
let cycleScrollView = CycleScrollView.initScrollView(frame: frame, delegate: self, placehoder: UIImage.init(named: "place.png"), cycleOptions: CycleOptions())
cycleScrollView.imageURLStringsGroup = imageUrls
```
#### 通过单独抽取一个struct来管理各种轮播器的各个属性
```
import UIKit

public enum PageControlStyle {
    case classic,aji,aleppo,chimayo,jalapeno,jaloro,paprika,puya
}
public enum PageControlAliment {
    case center,right
}

public struct CycleOption {
    public  var scrollDirection:UICollectionViewScrollDirection = UICollectionViewScrollDirection.horizontal
    public  var showPageControl: Bool = true//是否显示pageControl,默认显示
    public  var isOnlyDisplayText: Bool = false//只显示文字,默认false
    public  var imageViewMode: UIViewContentMode = UIViewContentMode.scaleToFill //图片填充样式,默认fill
    public  var scrollTimeInterval: TimeInterval = 2.0//滑动间隔时间
    public  var titleLabelBackgroundColor: UIColor = .init(red: 0, green: 0, blue: 0, alpha: 0.2)//label背景颜色
    public  var textColor: UIColor = .white//文字颜色
    public  var textFont: UIFont = UIFont.systemFont(ofSize: 14)//文字字体大小
    public  var titleLabelHeight: CGFloat = 30//label高度,默认30
    public  var textAlignment: NSTextAlignment = NSTextAlignment.left//文字默认居左
    public  var numberOfline = 1 // 文字行数,默认一行
    public  var radius: CGFloat = 5//pageControl圆点半径
    public  var pageAliment: PageControlAliment = PageControlAliment.center//pageControl位置,默认居中
    public  var bottomOffset: CGFloat = 0//pageControl距离底部距离
    public  var rightOffset: CGFloat = 0//pageControl距离右侧距离
    public  var padding: CGFloat = 7 //pagecontol间距
    public  var pageStyle: PageControlStyle = PageControlStyle.classic//pageControl样式,默认系统样式
    public  var currentPageDotColor: UIColor = .white//当前pageControl圆点的颜色
    public  var pageDotColor: UIColor = .gray//其他pageControl圆点的颜色
}
```
#### 点击图片代理
代理名称SBCycleScrollViewDelegate,代理方法
```
func didSelectedCycleScrollView(_ cycleScrollView: SBCycleScrollView, _ Index: NSInteger) {
        print("点击了第\(Index)张图片")
    }
```
####修改配置属性,达到你想要的效果
```
\\先配置再初始化
        var option = CycleOption()
        option.currentPageDotColor = .blue
        option.radius = 10
        option.pageStyle = PageControlStyle.jalapeno
        let cycleScrollView = CycleScrollView.initScrollView(frame: view.frame, imageURLsGroup: imageUrls, cycleOption: option)
\\初始化后再修改配置
        let cycleScrollView = CycleScrollView.initScrollView(frame: view.frame, imageURLsGroup: imageUrls, cycleOption: CycleOption())
        var option = CycleOption()
        option.currentPageDotColor = .blue
        option.radius = 10
        option.pageStyle = PageControlStyle.jalapeno
        cycleScrollView.option = option
```
####点击图片代理
代理名称SBCycleScrollViewDelegate,代理方法
```
 func didSelectedCycleScrollView(_ cycleScrollView: CycleScrollView, _ Index: NSInteger) {
        print("点击了第\(Index)张图片")
    }
```
# 效果图展示:
![](https://upload-images.jianshu.io/upload_images/1220329-e0a6d0c3e7d41be8.gif?imageMogr2/auto-orient/strip)

![](https://upload-images.jianshu.io/upload_images/1220329-4be3f85fa74e4396.gif?imageMogr2/auto-orient/strip)

![](https://upload-images.jianshu.io/upload_images/1220329-a54812076de12935.gif?imageMogr2/auto-orient/strip)

![](https://upload-images.jianshu.io/upload_images/1220329-509c04f4997380a8.gif?imageMogr2/auto-orient/strip)

![](https://upload-images.jianshu.io/upload_images/1220329-2975a790910e946a.gif?imageMogr2/auto-orient/strip)

![](https://upload-images.jianshu.io/upload_images/1220329-217dad2580cb94e7.gif?imageMogr2/auto-orient/strip)

![](https://upload-images.jianshu.io/upload_images/1220329-d6ec969567d2b455.gif?imageMogr2/auto-orient/strip)

![](https://upload-images.jianshu.io/upload_images/1220329-4b2a8d64f0980082.gif?imageMogr2/auto-orient/strip)

### 结语
#### 如果这个组件能够帮助到你我会非常开心,当然我也希望有大佬能够帮我指出我代码中的问题,毕竟我学swift时间不久,代码还有很多不足的地方,如果可以,非常感谢. 
### 希望大家能给个star,你们的鼓励是我前进的动力.

[Github地址,欢迎star😆](https://github.com/xumaohuai/SBCycleScrollView)
