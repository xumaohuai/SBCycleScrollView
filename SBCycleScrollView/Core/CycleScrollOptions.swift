//
//  CycleScrollOptions.swift
//  CycleScrollViewDemo
//
//  Created by 徐茂怀 on 2018/6/25.
//  Copyright © 2018年 徐茂怀. All rights reserved.
//

import UIKit

public enum PageControlStyle {
    case classic,aji,aleppo,chimayo,jalapeno,jaloro,paprika,puya
}
public enum PageControlAliment {
    case center,right
}

public struct CycleOptions {
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
    public init() {
        
    }
}

