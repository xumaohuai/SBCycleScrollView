//
//  CycleScrollView.swift
//  CycleScrollView
//
//  Created by 徐茂怀 on 2018/6/13.
//  Copyright © 2018年 徐茂怀. All rights reserved.
//

import UIKit
import Kingfisher

//MARK: 点击图片代理
@objc public protocol CycleScrollViewDelegate : NSObjectProtocol {
    @objc optional func didSelectedCycleScrollView(_ cycleScrollView : CycleScrollView, _ Index : NSInteger)
}

 open class CycleScrollView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
    private let ID = "CycleScrollViewCell"
    var options : CycleOptions = CycleOptions(){
        didSet {
            flowLayout.scrollDirection = options.scrollDirection
            setupPageControl()
        }
    }
    var backgroundImageView : UIImageView?//背景图片,用来显示占位图
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
 
    //MARK:数据源相关
    open var titlesGroup = [String]() //标题数组
    var delegate : CycleScrollViewDelegate?
    open var imageURLStringsGroup = [String](){ //设置网络图片地址数组,并刷新Collectionview
        didSet {
            imagePathsGroup = imageURLStringsGroup
        }
    }
    open var imageNamesGroup = [String](){//设置本地图片名称数组,并刷新Collectionview
        didSet {
            imagePathsGroup = imageNamesGroup
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
    
    static public func initScrollView( frame: CGRect, delegate: CycleScrollViewDelegate?, placehoder: UIImage?,cycleOptions: CycleOptions?) -> CycleScrollView {
        return CycleScrollView.initScrollView(frame: frame, imageURLsGroup: nil, imageNamesGroup: nil, cycleOptions: cycleOptions, titleGroups: nil, delegate: delegate, placehoder: placehoder)
    }

    static public func initScrollView( frame: CGRect, imageNamesGroup: Array<String>?,cycleOptions: CycleOptions?) -> CycleScrollView{
        return CycleScrollView.initScrollView(frame: frame, imageURLsGroup: nil, imageNamesGroup: imageNamesGroup, cycleOptions: cycleOptions, titleGroups: nil, delegate: nil, placehoder: nil)
    }

    static public func initScrollView( frame : CGRect, imageURLsGroup : Array<String>?, cycleOption: CycleOptions?) -> CycleScrollView {
        return CycleScrollView.initScrollView(frame: frame, imageURLsGroup: imageURLsGroup, imageNamesGroup: nil, cycleOptions: cycleOption, titleGroups: nil, delegate: nil, placehoder: nil)
    }
    static public func initScrollView( frame : CGRect, titleGroup : Array<String>?, cycleOption: CycleOptions?) -> CycleScrollView {
        return CycleScrollView.initScrollView(frame: frame, imageURLsGroup: nil, imageNamesGroup: nil, cycleOptions: cycleOption, titleGroups: titleGroup, delegate: nil, placehoder: nil)
    }
    
    static private func initScrollView(frame: CGRect, imageURLsGroup: Array<String>?,imageNamesGroup: Array<String>?,cycleOptions: CycleOptions?,titleGroups: Array<String>?,delegate : CycleScrollViewDelegate?,  placehoder : UIImage?) -> CycleScrollView{
        let cycleScrollView = CycleScrollView.init(frame: frame)
        if imageURLsGroup != nil {
            cycleScrollView.imageURLStringsGroup = imageURLsGroup!
            if imageURLsGroup!.count > 1 {
                cycleScrollView.setupTimer()
            }else{
                cycleScrollView.invalidateTimer()
            }
        }
        if imageNamesGroup != nil {
            cycleScrollView.imageNamesGroup = imageNamesGroup!
            if imageNamesGroup!.count > 1 {
                cycleScrollView.setupTimer()
            }else{
                cycleScrollView.invalidateTimer()
            }
        }
        if titleGroups != nil {
            cycleScrollView.titlesGroup = titleGroups!
            if titleGroups!.count > 1 {
                cycleScrollView.setupTimer()
            }else{
                cycleScrollView.invalidateTimer()
            }
        }
        if cycleOptions != nil {
            cycleScrollView.options = cycleOptions!
        }else{
            cycleScrollView.options = CycleOptions()
        }
        if delegate != nil {
            cycleScrollView.delegate = delegate!
        }
        if placehoder != nil {
            cycleScrollView.placeholderImage = placehoder!
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
            size = con.sizeForPages(imageNamesGroup.count)
        }else{
            size = CGSize.init(width: CGFloat(imagePathsGroup.count * 2) * options.radius , height: options.radius * 2)
        }
        var x = (mainView.width - size.width) / 2
        if options.pageAliment == PageControlAliment.right{
            x = width - size.width - 10
        }
        let y = mainView.height - size.height - 10
        var pageControlFrame = CGRect.init(x: x, y: y, width: size.width, height: size.height)
        pageControlFrame.origin.y -= options.bottomOffset
        pageControlFrame.origin.x -= options.rightOffset
        pageControl.frame = pageControlFrame
        pageControl.isHidden = !options.showPageControl
    }
    
    func pageControlIndexWithCurrentCellIndex(_ index : NSInteger) -> Int {
        return Int(index % imagePathsGroup.count)
    }
    
    private func setupMainView() {
        flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = options.scrollDirection
        mainView = UICollectionView.init(frame: bounds, collectionViewLayout: flowLayout!)
        mainView.backgroundColor = .clear
        mainView.isPagingEnabled = true
        mainView.showsVerticalScrollIndicator = false
        mainView.showsHorizontalScrollIndicator = false
        mainView.register(CollectionViewCell.classForCoder(), forCellWithReuseIdentifier: ID)
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
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(options.scrollTimeInterval), target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
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
            if options.scrollDirection == UICollectionViewScrollDirection.horizontal {
                mainView.scrollToItem(at: IndexPath.init(row: index, section: 0) , at: UICollectionViewScrollPosition.left, animated: false)
            }else {
                mainView.scrollToItem(at: IndexPath.init(row: index, section: 0) , at: UICollectionViewScrollPosition.top, animated: false)
            }
        }
        if options.scrollDirection == UICollectionViewScrollDirection.horizontal {
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
    func setupPageControl() {
        pageControl.removeFromSuperview()
        if imagePathsGroup.count == 0 || options.isOnlyDisplayText {
            return
        }
        if imagePathsGroup.count == 1{
            return
        }
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(currentIndex())
        switch options.pageStyle {
        case .classic:
            let control : UIPageControl  = UIPageControl.init(frame: .init(x: 100, y: 100, width: 100, height: 30))
            control.numberOfPages = imagePathsGroup.count
            control.currentPageIndicatorTintColor = options.currentPageDotColor
            control.pageIndicatorTintColor = options.pageDotColor
            control.currentPage = indexOnPageControl
            control.transform = CGAffineTransform.init(scaleX: options.radius / 5, y: options.radius / 5)
            pageControl = control
            addSubview(pageControl)
        case .jalapeno:
            let control : CHIPageControlJalapeno = CHIPageControlJalapeno.init(frame: .init(x: 100, y: 100, width: 100, height: 30))
            control.numberOfPages = imagePathsGroup.count
            control.currentPageTintColor = options.currentPageDotColor
            control.tintColor = options.pageDotColor
            control.radius = options.radius
            control.padding = options.padding
            pageControl = control
            addSubview(pageControl)
        case .aji:
            let control : CHIPageControlAji = CHIPageControlAji.init(frame: .init(x: 100, y: 100, width: 100, height: 30))
            control.numberOfPages = imagePathsGroup.count
            control.currentPageTintColor = options.currentPageDotColor
            control.tintColor = options.pageDotColor
            control.radius = options.radius
            control.padding = options.padding
            pageControl = control
            addSubview(pageControl)
        case .aleppo:
            let control : CHIPageControlAleppo = CHIPageControlAleppo.init(frame: .init(x: 100, y: 100, width: 100, height: 30))
            control.numberOfPages = imagePathsGroup.count
            control.currentPageTintColor = options.currentPageDotColor
            control.tintColor = options.pageDotColor
            control.radius = options.radius
            control.padding = options.padding
            pageControl = control
            addSubview(pageControl)
        case .chimayo:
            let control : CHIPageControlChimayo = CHIPageControlChimayo.init(frame: .init(x: 100, y: 100, width: 100, height: 30))
            control.numberOfPages = imagePathsGroup.count
            control.tintColor = options.currentPageDotColor
            control.radius = options.radius
            control.padding = options.padding
            pageControl = control
            addSubview(pageControl)
        case .jaloro:
            let control : CHIPageControlJaloro = CHIPageControlJaloro.init(frame: .init(x: 100, y: 100, width: 100, height: 30))
            control.numberOfPages = imagePathsGroup.count
            control.currentPageTintColor = options.currentPageDotColor
            control.tintColor = options.pageDotColor
            control.elementHeight = options.radius
            control.padding = options.padding
            pageControl = control
            addSubview(pageControl)
        case .paprika:
            let control : CHIPageControlPaprika = CHIPageControlPaprika.init(frame: .init(x: 100, y: 100, width: 100, height: 30))
            control.numberOfPages = imagePathsGroup.count
            control.currentPageTintColor = options.currentPageDotColor
            control.tintColor = options.pageDotColor
            control.radius = options.radius
            control.padding = options.padding
            pageControl = control
            addSubview(pageControl)
        case .puya:
            let control : CHIPageControlPuya = CHIPageControlPuya.init(frame: .init(x: 100, y: 100, width: 100, height: 30))
            control.numberOfPages = imagePathsGroup.count
            control.currentPageTintColor = options.currentPageDotColor
            control.tintColor = options.pageDotColor
            control.radius = options.radius
            control.padding = options.padding
            pageControl = control
            addSubview(pageControl)
        }
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
//MARK:UIScrollViewDelegate
extension CycleScrollView{
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if imagePathsGroup.count == 0 {
            return
        }
        let itemIndex = currentIndex()
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(itemIndex)
        var total =  CGFloat(imagePathsGroup.count - 1) * scrollView.bounds.width
        var offset = scrollView.contentOffset.x.truncatingRemainder(dividingBy:(scrollView.bounds.width * (CGFloat)(imagePathsGroup.count)))
        if options.scrollDirection == UICollectionViewScrollDirection.vertical {
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
}

//MARK: UICollectionViewDelegate,UICollectionViewDataSource代理
extension CycleScrollView{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItemsCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! CollectionViewCell
        let itemIndex = pageControlIndexWithCurrentCellIndex(indexPath.item)
        let imagePath : String = imagePathsGroup[itemIndex]
        if  !options.isOnlyDisplayText {
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
            cell.titleLabelBackgroundColor = options.titleLabelBackgroundColor
            cell.titleLabelHeight = options.titleLabelHeight
            cell.titleLabelTextAlignment = options.textAlignment
            cell.titleLabelTextColor = options.textColor
            cell.titleLabelTextFont = options.textFont
            cell.imageView.contentMode = options.imageViewMode
            cell.isConfigured = true
            cell.clipsToBounds = true
            cell.isOnlyDisplayText = options.isOnlyDisplayText
            cell.numberOfLine  = options.numberOfline
        }
        return cell
    }
    
  
}
extension CycleScrollView{
    //MARK:CycleScrollViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if delegate != nil && (delegate?.responds(to: #selector(CycleScrollViewDelegate.didSelectedCycleScrollView(_:_:))))!{
            delegate?.didSelectedCycleScrollView!(self, pageControlIndexWithCurrentCellIndex(indexPath.item))
        }
    }
}

