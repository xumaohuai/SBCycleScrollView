# SBCycleScrollView
## ☆☆☆ “功能强大的图片、文字轮播器,支持纯文字、网络图片、本地图片、图片加文字以及各种圆点样式” ☆☆☆

### 支持pod导入
pod 'SBCycleScrollView','~> 0.0.4'


#### SBCycleScrollView是一个简单好用的图片轮播器,支持网络图片,本地图片,文字,滑动方向,storyboard以及各种样式.
[Github地址,欢迎star😆](https://github.com/xumaohuai/SBCycleScrollView)
### 使用方式
使用cocoapods导入,pod 'SBCycleScrollView','~>0.0.4',如果发现pod search SBCycleScrollView 搜索出来的不是最新版本，请先执行pod setup指令,获取最新数据源就可以了.
### 提供三种初始化方式
```
\\通过网络图片地址初始化
let cycleScrollView = SBCycleScrollView.initScrollView(frame: frame, imageURLsGroup: imageUrls)
```
```
\\通过本地图片名称或地址初始化
let cycleScrollView = SBCycleScrollView.initScrollView(frame: frame, imageNamesGroup: imageNames)
```
```
\\推荐方式,通过代理和占位图初始化,常用于图片异步获取的时候
let cycleScrollView = SBCycleScrollView.initScrollView(frame: frame, delegate: self, placehoder: UIImage.init(named: "place.jpg")!)
cycleScrollView.imageURLStringsGroup = imageUrls
```
### 支持的属性
```
//滑动方向
cycleScrollView.scrollDirection = UICollectionViewScrollDirection.vertical
//滑动时间间隔,默认2s
cycleScrollView.ScrollTimeInterval = 2.0
//当前圆点颜色
cycleScrollView.currentPageDotColor = UIColor.red
//其他圆点颜色
cycleScrollView.pageDotColor = UIColor.blue
//圆点半径
cycleScrollView.pageControlDotRadius = 10
//文字数组
cycleScrollView.titlesGroup = titles
//pageControl位置,可以居中和居右(默认居中)
cycleScrollView.pageControlAliment = SBPageControlAliment.right
//是否只显示文字,默认false
cycleScrollView.isOnlyDisplayText = true
//是否显示圆点,默认true
cycleScrollView.showPageControl = false
//文字默认居做
cycleScrollView.TextAlignment = NSTextAlignment.center
//pageControl样式,默认系统样式,另外还提供了7种不同的样式
cycleScrollView.pageControlStyle = SBPageControlStyle.Aji
//只有一张图片时默认隐藏pageControl
cycleScrollView.hidesForSinglePage = true
//pagecontrol距离底部距离
cycleScrollView.pageControlBottomOffset = 0
//pageControl距离右侧距离
cycleScrollView.pageControlRightOffset = true
//文字颜色
cycleScrollView.TextColor = .white
//字体大小
cycleScrollView.TextFont = UIFont.systemFont(ofSize: 14)
//label背景色
cycleScrollView.titleLabelBackgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
//Label高度
cycleScrollView.titleLabelHeight = 30
//占位图
cycleScrollView.placeholderImage = UIImage.init()
//文字行数,默认一行
cycleScrollView.titleNumberOfLine = 1
//图片填充样式,默认fill
cycleScrollView.imageViewContentMode = UIViewContentMode.scaleToFill
//pageControl间距
cycleScrollView.padding = 7
```
#### 点击图片代理
代理名称SBCycleScrollViewDelegate,代理方法
```
func didSelectedCycleScrollView(_ cycleScrollView: SBCycleScrollView, _ Index: NSInteger) {
        print("点击了第\(Index)张图片")
    }
```
#### 支持在StoryBoard中直接修改的属性
在故事版里面,拖入一个UIView,继承SBCycleScrollView,就可以在其属性界面直接修改了.如图:
![storyboard属性](https://upload-images.jianshu.io/upload_images/1220329-fe13b7365e5ba009.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
# 效果图展示:
![
](https://upload-images.jianshu.io/upload_images/1220329-f2e9b3de1461590e.gif?imageMogr2/auto-orient/strip)
![](https://upload-images.jianshu.io/upload_images/1220329-4f69527e854a5213.gif?imageMogr2/auto-orient/strip)
![](https://upload-images.jianshu.io/upload_images/1220329-1667c139562add41.gif?imageMogr2/auto-orient/strip)
![](https://upload-images.jianshu.io/upload_images/1220329-77270912fdc2d8d4.gif?imageMogr2/auto-orient/strip)
![](https://upload-images.jianshu.io/upload_images/1220329-cbdad0b6cce8aefe.gif?imageMogr2/auto-orient/strip)
![](https://upload-images.jianshu.io/upload_images/1220329-44136bed8c1adf8d.gif?imageMogr2/auto-orient/strip)

### 结语
##### 如果这个组件能够帮助到你我会非常开心,当然我也希望有大佬能够帮我指出我代码中的问题,毕竟我学swift时间不久,代码还有很多不足的地方,如果可以,非常感谢. 
### 希望大家能给个star,你们的鼓励是我前进的动力.

[Github地址,欢迎star😆](https://github.com/xumaohuai/SBCycleScrollView)
