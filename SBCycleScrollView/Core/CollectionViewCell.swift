//
//  CollectionViewCell.swift
//  CycleScrollView
//
//  Created by 徐茂怀 on 2018/6/13.
//  Copyright © 2018年 徐茂怀. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    var imageView : UIImageView!
    var isConfigured : Bool! = false
    var numberOfLine : NSInteger = 1{
        didSet {
            titleLabel?.numberOfLines = numberOfLine
        }
    }
    var title : String?{
        didSet {
            titleLabel?.text = title
            if (titleLabel?.isHidden)! {
                titleLabel?.isHidden = false
            }
        }
    }
    var titleLabelTextColor : UIColor?{
        didSet {
            self.titleLabel?.textColor = titleLabelTextColor
        }
    }
    var titleLabelTextFont : UIFont?{
        didSet  {
            self.titleLabel?.font = titleLabelTextFont
        }
    }
    var titleLabelBackgroundColor : UIColor?{
        didSet {
            titleLabel?.backgroundColor = titleLabelBackgroundColor
        }
    }
    var titleLabelHeight : CGFloat = 30
    var titleLabelTextAlignment : NSTextAlignment?{
        didSet {
            self.titleLabel?.textAlignment = titleLabelTextAlignment!
        }
    }
    var isOnlyDisplayText : Bool?
    private var titleLabel : UILabel?
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.isOnlyDisplayText = false
        setupImageView()
        setupTitleLabel()
    }
    
    func setupImageView(){
        imageView = UIImageView.init()
        self.contentView.addSubview(imageView!)
    }
    func setupTitleLabel() {
        titleLabel = UILabel.init()
        titleLabel?.isHidden = true
        self.contentView.addSubview(titleLabel!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if self.isOnlyDisplayText! {
            titleLabel?.frame = bounds
        }else {
            imageView?.frame = bounds
            titleLabel?.frame = .init(x: 0, y: height - titleLabelHeight, width: width, height: titleLabelHeight)
        }
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
