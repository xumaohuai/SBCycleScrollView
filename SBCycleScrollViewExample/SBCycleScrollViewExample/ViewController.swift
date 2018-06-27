//
//  ViewController.swift
//  CycleScrollView
//
//  Created by 徐茂怀 on 2018/6/13.
//  Copyright © 2018年 徐茂怀. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,CycleScrollViewDelegate{
    let descrips = ["网络图片","本地图片","上下滑动","按钮颜色","按钮大小","图片+文字","纯文字","SBPageControlStyle.Aji","SBPageControlStyle.Aleppo","SBPageControlStyle.Chimayo","SBPageControlStyle.Jalapeno","SBPageControlStyle.Jaloro","SBPageControlStyle.Paprika","SBPageControlStyle.Puya"]
    let imageUrls = ["https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3711690120,1162131576&fm=27&gp=0.jpg","https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1274844101,636774309&fm=27&gp=0.jpg","https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1185573334,16415454&fm=27&gp=0.jpg","https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2536078587,1520810066&fm=27&gp=0.jpg"]
    let titles = ["https://github.com/","有问题可以联系我","我的qq:1005834829","简书博客搜索:徐老茂"]
    let localImages = ["1.jpg","2.jpg","3.jpg"]
    
    lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: view.width, height: view.height - 64), style: UITableViewStyle.plain)
        tableView.register(DemoCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        title = "SBCycleScrollView"
        view.addSubview(tableView)
    }
}

//MARK:UITableViewDelegate,UITableViewDataSource
extension ViewController{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 6 {
            return 40
        }
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return descrips.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return descrips[section]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DemoCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        var op = CycleOptions()
        cell.cycleScrollView.imageURLStringsGroup = imageUrls
        switch indexPath.section {
        case 1:
            cell.cycleScrollView.imageNamesGroup = localImages
        case 2:
            op.scrollDirection = UICollectionViewScrollDirection.vertical
        case 3:
            op.currentPageDotColor = .red
            op.pageDotColor = .blue
        case 4:
            op.radius = 10
        case 5:
            op.pageAliment = PageControlAliment.right
            cell.cycleScrollView.titlesGroup = titles
        case 6:
            op.textAlignment = NSTextAlignment.center
            op.isOnlyDisplayText = true
            op.showPageControl = false
            op.scrollDirection = UICollectionViewScrollDirection.vertical

            cell.cycleScrollView.titlesGroup = titles;
            cell.cycleScrollView.disableScrollGesture()
        case 7:
            op.currentPageDotColor = UIColor(red:0.4, green:0.53, blue:1, alpha:1)
            op.pageDotColor = .white
            op.pageStyle = PageControlStyle.aji
            op.radius = 7
        case 8:
            op.pageStyle = PageControlStyle.aleppo
            op.radius = 7
            op.currentPageDotColor = UIColor(red:0.4, green:0.53, blue:1, alpha:1)
            op.pageDotColor = .white
        case 9:
            op.pageStyle = PageControlStyle.chimayo
            op.radius = 7
            op.currentPageDotColor = .white
            
        case 10:
            op.pageStyle = PageControlStyle.jalapeno
            op.radius = 7
            op.currentPageDotColor = UIColor(red:0.4, green:0.53, blue:1, alpha:1)
            op.pageDotColor = .white
        case 11:
            op.pageStyle = PageControlStyle.jaloro
            op.radius = 7
            op.currentPageDotColor = UIColor(red:0.4, green:0.53, blue:1, alpha:1)
            op.pageDotColor = .white
        case 12:
            op.pageStyle = PageControlStyle.paprika
            op.radius = 7
            op.currentPageDotColor = UIColor(red:0.4, green:0.53, blue:1, alpha:1)
            op.pageDotColor = .white
        case 13:
            op.pageStyle = PageControlStyle.puya
            op.radius = 7
            op.currentPageDotColor = UIColor(red:0.4, green:0.53, blue:1, alpha:1)
            op.pageDotColor = .white
        default: break
        }
        cell.cycleScrollView.options = op
        return cell
    }
}

