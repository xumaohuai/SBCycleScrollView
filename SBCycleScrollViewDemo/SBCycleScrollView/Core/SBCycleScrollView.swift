//
//  SBCycleScrollView.swift
//  SBCycleScrollView
//
//  Created by 徐茂怀 on 2018/6/13.
//  Copyright © 2018年 徐茂怀. All rights reserved.
//

import UIKit
import Kingfisher

//MARK: 点击图片代理
@objc public protocol SBCycleScrollViewDelegate : NSObjectProtocol {
    @objc optional func didSelectedCycleScrollView(_ cycleScrollView : SBCycleScrollView, _ Index : NSInteger)
}
public enum SBPageControlAliment {
    case center,right
}
public enum SBPageControlStyle {
    case Classic,Aji,Aleppo,Chimayo,Jalapeno,Jaloro,Paprika,Puya
}

@IBDesignable open class SBCycleScrollView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
    private let ID = "SBCycleScrollViewCell"
    //MARK: 自定义样式
    /**---------------------------------自定义样式------------------------------------------------*/
    @IBInspectable open var showPageControl : Bool = true//是否显示pageControl,默认显示
    open  var hidesForSinglePage : Bool = true//只有一页时候是否隐藏pagecontrol,默认隐藏
    open var isOnlyDisplayText : Bool = false//只显示文字,默认false
    open  var pageControlAliment : SBPageControlAliment = SBPageControlAliment.center//pageControl位置,默认居中
    open var pageControlStyle : SBPageControlStyle = SBPageControlStyle.Classic{ //pageControl样式,默认系统样式
        didSet {
            setupPageControl()
        }
    }
    @IBInspectable open var pageControlBottomOffset : CGFloat = 0//pageControl距离底部距离
    @IBInspectable open var pageControlRightOffset : CGFloat = 0//pageControl距离右侧距离
    //pageControl圆点半径
    @IBInspectable open var pageControlDotRadius : CGFloat = 5{
        didSet {
            setupPageControl()
        }
    }
    //当前pageControl圆点的颜色
    @IBInspectable open var currentPageDotColor : UIColor = .white{
        didSet{
            switch pageControl {
            case is UIPageControl:
                let con = pageControl as! UIPageControl
                con.currentPageIndicatorTintColor = currentPageDotColor
            case is CHIBasePageControl:
                let con = pageControl as! CHIBasePageControl
                con.currentPageTintColor = currentPageDotColor
            default:
                return
            }
        }
    }
    //其他pageControl圆点的颜色
    @IBInspectable open var pageDotColor : UIColor = .gray{
        didSet{
            switch pageControl {
            case is UIPageControl:
                let con = pageControl as! UIPageControl
                con.pageIndicatorTintColor = pageDotColor
            case is CHIBasePageControl:
                let con = pageControl as! CHIBasePageControl
                con.tintColor = pageDotColor
            default:
                return
            }
        }
    }
    @IBInspectable open var TextColor : UIColor = .white//文字颜色
    @IBInspectable open var TextFont : UIFont = UIFont.systemFont(ofSize: 14)//文字字体大小
    @IBInspectable open var titleLabelBackgroundColor : UIColor = .init(red: 0, green: 0, blue: 0, alpha: 0.2)//label背景颜色
    @IBInspectable open var titleLabelHeight : CGFloat = 30//label高度,默认30
    @IBInspectable open var TextAlignment : NSTextAlignment = NSTextAlignment.left//文字默认居左
    @IBInspectable open var backgroundImageView : UIImageView?//背景图片,用来显示占位图
    @IBInspectable open var titleNumberOfLine = 1 // 文字行数,默认一行
    @IBInspectable open var imageViewContentMode : UIViewContentMode = UIViewContentMode.scaleToFill //图片填充样式,默认fill
    //pagecontol间距
    open var padding : CGFloat = 7 {
        didSet {
            if pageControl is CHIBasePageControl {
                let con = pageControl as? CHIBasePageControl
                con?.padding = padding
            }
        }
    }
    //MARK:滚动相关
    /** --------------------------------滚动相关------------------------------------------------*/
    private var mainView : UICollectionView!
    private var flowLayout : UICollectionViewFlowLayout!
    private var totalItemsCount  = 0
    lazy var pageControl : UIControl = {
        let control  = UIControl.init()
        return control
    }()
    private var timer : Timer!
    //滚动方向,默认横向滑动
    open var scrollDirection : UICollectionViewScrollDirection = UICollectionViewScrollDirection.horizontal{
        didSet{
            flowLayout.scrollDirection = scrollDirection
        }
    }
    //滑动间隔时间
    open var ScrollTimeInterval : CGFloat = 2.0
    
    //MARK:数据源相关
    open var titlesGroup = [String]() //标题数组
    var delegate : SBCycleScrollViewDelegate?
    open var imageURLStringsGroup = [String](){ //设置网络图片地址数组,并刷新Collectionview
        didSet {
            imagePathsGroup = imageURLStringsGroup
        }
    }
    open var ImageNamesGroup = [String](){//设置本地图片名称数组,并刷新Collectionview
        didSet {
            imagePathsGroup = ImageNamesGroup
        }
    }
    open var imagePathsGroup = [String](){
        didSet {
            totalItemsCount = imagePathsGroup.count * 100
            if imagePathsGroup.count > 1 {
                mainView.isScrollEnabled = true
                setupTimer()
            }else {
                mainView.isScrollEnabled = false
                invalidateTimer()
            }
            setupPageControl()
            mainView.reloadData()
        }
    }
    open var placeholderImage : UIImage = UIImage.init() {//展位图
        didSet {
            if backgroundImageView == nil {
                backgroundImageView = UIImageView.init()
                backgroundImageView?.contentMode = UIViewContentMode.scaleToFill
                insertSubview(backgroundImageView!, belowSubview: mainView!)
                backgroundImageView?.image = placeholderImage
            }
        }
    }
    
    //MARK:初始化
    /// 初始轮播图（推荐使用）
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - delegate: 代理
    ///   - placehoder: 展位图
    static public func initScrollView( frame : CGRect, delegate : SBCycleScrollViewDelegate,  placehoder : UIImage) -> SBCycleScrollView {
        let cycleScrollView = SBCycleScrollView.init(frame: frame)
        cycleScrollView.delegate = delegate
        cycleScrollView.placeholderImage = placehoder
        return cycleScrollView
    }
    /// 本地图片轮播初始化方式
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - imageNamesGroup: 图片名称数组
    static public func initScrollView( frame : CGRect, imageNamesGroup : Array<String>!) -> SBCycleScrollView{
        let cycleScrollView = SBCycleScrollView.init(frame: frame)
        cycleScrollView.imagePathsGroup = imageNamesGroup
        if imageNamesGroup.count > 1 {
            cycleScrollView.setupTimer()
        }else{
            cycleScrollView.invalidateTimer()
        }
        return cycleScrollView
    }
    
    /// 网络图片轮播初始化方式
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - imageURLsGroup: 网络图片地址数组
    static public func initScrollView( frame : CGRect, imageURLsGroup : Array<String>!) -> SBCycleScrollView {
        let cycleScrollView = SBCycleScrollView.init(frame: frame)
        cycleScrollView.imagePathsGroup = imageURLsGroup
        if imageURLsGroup.count > 1 {
            cycleScrollView.setupTimer()
        }else{
            cycleScrollView.invalidateTimer()
        }
        return cycleScrollView
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupMainView()
        backgroundColor = .lightGray
    }
    override open func awakeFromNib() {
        super.awakeFromNib()
        setupMainView()
        backgroundColor = .lightGray
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        flowLayout?.itemSize = bounds.size
        mainView?.frame = bounds
        if mainView?.contentOffset.x == 0 && totalItemsCount > 0 {
            let targetIndex = Int(totalItemsCount / 2)
            mainView?.scrollToItem(at: IndexPath.init(row: targetIndex, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
        }
        var size = CGSize.zero
        if pageControl is CHIBasePageControl {
            let con = pageControl as! CHIBasePageControl
            size = con.sizeForPages(ImageNamesGroup.count)
        }else{
            size = CGSize.init(width: CGFloat(imagePathsGroup.count * 2) * pageControlDotRadius , height: pageControlDotRadius * 2)
        }
        var x = (mainView.width - size.width) / 2
        if pageControlAliment == SBPageControlAliment.right{
            x = width - size.width - 10
        }
        let y = mainView.height - size.height - 10
        var pageControlFrame = CGRect.init(x: x, y: y, width: size.width, height: size.height)
        pageControlFrame.origin.y -= pageControlBottomOffset
        pageControlFrame.origin.x -= pageControlRightOffset
        pageControl.frame = pageControlFrame
        pageControl.isHidden = !showPageControl
    }
    
    private func setupMainView() {
        flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = scrollDirection
        
        mainView = UICollectionView.init(frame: bounds, collectionViewLayout: flowLayout!)
        mainView.backgroundColor = .clear
        mainView.isPagingEnabled = true
        mainView.showsVerticalScrollIndicator = false
        mainView.showsHorizontalScrollIndicator = false
        mainView.register(SBCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: ID)
        mainView.dataSource = self
        mainView.delegate = self
        mainView.scrollsToTop = false
        addSubview(mainView!)
    }
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    func setupTimer() {
        invalidateTimer()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(ScrollTimeInterval), target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    @objc func automaticScroll()  {
        if totalItemsCount == 0 {
            return
        }
        let currentIndex : Int = self.currentIndex();
        var targetIndex = currentIndex + 1;
        scrollToIndex(&targetIndex)
    }
    func scrollToIndex(_ index : inout Int) {
        if index >= totalItemsCount {
            index = totalItemsCount / 2
            if scrollDirection == UICollectionViewScrollDirection.horizontal {
                mainView.scrollToItem(at: IndexPath.init(row: index, section: 0) , at: UICollectionViewScrollPosition.left, animated: false)
            }else {
                mainView.scrollToItem(at: IndexPath.init(row: index, section: 0) , at: UICollectionViewScrollPosition.top, animated: false)
            }
        }
        if scrollDirection == UICollectionViewScrollDirection.horizontal {
            mainView.scrollToItem(at: IndexPath.init(row: index, section: 0) , at: UICollectionViewScrollPosition.left, animated: true)
        }else {
            mainView.scrollToItem(at: IndexPath.init(row: index, section: 0) , at: UICollectionViewScrollPosition.top, animated: true)
        }
    }
    func currentIndex() -> Int {
        if (mainView.width == 0 || mainView.height == 0) {
            return 0;
        }
        var index : Int = 0
        if flowLayout.scrollDirection == UICollectionViewScrollDirection.horizontal {
            index = Int((mainView.contentOffset.x + flowLayout.itemSize.width / 2) / flowLayout.itemSize.width)
        } else {
            index = Int((mainView.contentOffset.y + flowLayout.itemSize.height / 2) / flowLayout.itemSize.height)
        }
        return max(0, index);
    }
    
    
    //MARK: UICollectionViewDelegate,UICollectionViewDataSource代理
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItemsCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! SBCollectionViewCell
        let itemIndex = pageControlIndexWithCurrentCellIndex(indexPath.item)
        let imagePath : String = imagePathsGroup[itemIndex]
        if  !isOnlyDisplayText {
            if imagePath.hasPrefix("http") {
                cell.imageView.kf.setImage(with: URL(string: imagePath), placeholder: placeholderImage)
            }else {
                var image  = UIImage.init(named: imagePath)
                if image == nil {
                    image = UIImage.init(contentsOfFile: imagePath)
                }
                cell.imageView?.image = image
            }
        }
        if titlesGroup.count > 0 && itemIndex < titlesGroup.count{
            cell.title = titlesGroup[itemIndex]
        }
        if (!cell.isConfigured) {
            cell.titleLabelBackgroundColor = titleLabelBackgroundColor
            cell.titleLabelHeight = titleLabelHeight
            cell.titleLabelTextAlignment = TextAlignment
            cell.titleLabelTextColor = TextColor
            cell.titleLabelTextFont = TextFont
            cell.isConfigured = true
            cell.imageView.contentMode = imageViewContentMode
            cell.clipsToBounds = true
            cell.isOnlyDisplayText = isOnlyDisplayText
            cell.numberOfLine  = titleNumberOfLine
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if delegate != nil && (delegate?.responds(to: #selector(SBCycleScrollViewDelegate.didSelectedCycleScrollView(_:_:))))!{
            delegate?.didSelectedCycleScrollView!(self, pageControlIndexWithCurrentCellIndex(indexPath.item))
        }
    }
    //MARK:UIScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if imagePathsGroup.count == 0 {
            return
        }
        let itemIndex = currentIndex()
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(itemIndex)
        var total =  CGFloat(imagePathsGroup.count - 1) * scrollView.bounds.width
        var offset = scrollView.contentOffset.x.truncatingRemainder(dividingBy:(scrollView.bounds.width * (CGFloat)(imagePathsGroup.count)))
        if scrollDirection == UICollectionViewScrollDirection.vertical {
            total = CGFloat(imagePathsGroup.count - 1) * scrollView.bounds.height
            offset = scrollView.contentOffset.y.truncatingRemainder(dividingBy:(scrollView.bounds.height * (CGFloat)(imagePathsGroup.count)))
        }
        let percent = Double(offset / total)
        let progress = percent * Double(imagePathsGroup.count - 1)
        switch pageControl {
        case is UIPageControl:
            let con = pageControl as! UIPageControl
            con.currentPage = indexOnPageControl
        case is CHIBasePageControl:
            let con = pageControl as! CHIBasePageControl
            con.progress = progress
        default:
            return
        }
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        invalidateTimer()
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setupTimer()
    }
    
    func setupPageControl() {
        
        pageControl.removeFromSuperview()
        
        if imagePathsGroup.count == 0 || isOnlyDisplayText {
            return
        }
        if imagePathsGroup.count == 1 && hidesForSinglePage {
            return
        }
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(currentIndex())
        switch pageControlStyle {
        case .Classic:
            let control : UIPageControl  = UIPageControl.init(frame: .init(x: 100, y: 100, width: 100, height: 30))
            control.numberOfPages = imagePathsGroup.count
            control.currentPageIndicatorTintColor = currentPageDotColor
            control.pageIndicatorTintColor = pageDotColor
            control.currentPage = indexOnPageControl
            control.transform = CGAffineTransform.init(scaleX: pageControlDotRadius / 5, y: pageControlDotRadius / 5)
            pageControl = control
            addSubview(pageControl)
        case .Jalapeno:
            let control : CHIPageControlJalapeno = CHIPageControlJalapeno.init(frame: .init(x: 100, y: 100, width: 100, height: 30))
            control.numberOfPages = imagePathsGroup.count
            control.currentPageTintColor = currentPageDotColor
            control.tintColor = pageDotColor
            control.radius = pageControlDotRadius
            pageControl = control
            addSubview(pageControl)
        case .Aji:
            let control : CHIPageControlAji = CHIPageControlAji.init(frame: .init(x: 100, y: 100, width: 100, height: 30))
            control.numberOfPages = imagePathsGroup.count
            control.currentPageTintColor = currentPageDotColor
            control.tintColor = pageDotColor
            control.radius = pageControlDotRadius
            pageControl = control
            addSubview(pageControl)
        case .Aleppo:
            let control : CHIPageControlAleppo = CHIPageControlAleppo.init(frame: .init(x: 100, y: 100, width: 100, height: 30))
            control.numberOfPages = imagePathsGroup.count
            control.currentPageTintColor = currentPageDotColor
            control.tintColor = pageDotColor
            control.radius = pageControlDotRadius
            pageControl = control
            addSubview(pageControl)
        case .Chimayo:
            let control : CHIPageControlChimayo = CHIPageControlChimayo.init(frame: .init(x: 100, y: 100, width: 100, height: 30))
            control.numberOfPages = imagePathsGroup.count
            control.tintColor = currentPageDotColor
            control.radius = pageControlDotRadius
            pageControl = control
            addSubview(pageControl)
        case .Jaloro:
            let control : CHIPageControlJaloro = CHIPageControlJaloro.init(frame: .init(x: 100, y: 100, width: 100, height: 30))
            control.numberOfPages = imagePathsGroup.count
            control.currentPageTintColor = currentPageDotColor
            control.tintColor = pageDotColor
            control.elementHeight = pageControlDotRadius
            pageControl = control
            addSubview(pageControl)
        case .Paprika:
            let control : CHIPageControlPaprika = CHIPageControlPaprika.init(frame: .init(x: 100, y: 100, width: 100, height: 30))
            control.numberOfPages = imagePathsGroup.count
            control.currentPageTintColor = currentPageDotColor
            control.tintColor = pageDotColor
            control.radius = pageControlDotRadius
            pageControl = control
            addSubview(pageControl)
        case .Puya:
            let control : CHIPageControlPuya = CHIPageControlPuya.init(frame: .init(x: 100, y: 100, width: 100, height: 30))
            control.numberOfPages = imagePathsGroup.count
            control.currentPageTintColor = currentPageDotColor
            control.tintColor = pageDotColor
            control.radius = pageControlDotRadius
            pageControl = control
            addSubview(pageControl)
        }
    }
    
    //MARK:SBCycleScrollViewDelegate
    func pageControlIndexWithCurrentCellIndex(_ index : NSInteger) -> Int {
        return Int(index % imagePathsGroup.count)
    }
    //禁用拖拽手势
    open func disableScrollGesture() {
        mainView.canCancelContentTouches = false
        for gesture : UIGestureRecognizer in mainView.gestureRecognizers!{
            if gesture.isKind(of: UIPanGestureRecognizer.classForCoder()){
                mainView.removeGestureRecognizer(gesture)
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}
