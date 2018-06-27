//
//  DemoCell.swift
//  CycleScrollView
//
//  Created by 徐茂怀 on 2018/6/16.
//  Copyright © 2018年 徐茂怀. All rights reserved.
//

import UIKit


class DemoCell: UITableViewCell,CycleScrollViewDelegate {
    lazy var cycleScrollView : CycleScrollView =  {
        CycleScrollView.initScrollView(frame: self.bounds, delegate: self, placehoder: UIImage.init(named: "place.png"), cycleOptions: CycleOptions())
        
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(cycleScrollView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        cycleScrollView.frame = self.bounds
        cycleScrollView.delegate = self
        
    }
    //MARK:SBCycleScrollViewDelegate
    func didSelectedCycleScrollView(_ cycleScrollView: CycleScrollView, _ Index: NSInteger) {
        print("点击了第\(Index)张图片")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
