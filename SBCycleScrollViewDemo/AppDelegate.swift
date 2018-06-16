//
//  AppDelegate.swift
//  SBCycleScrollView
//
//  Created by 徐茂怀 on 2018/6/13.
//  Copyright © 2018年 徐茂怀. All rights reserved.
//
//本来很多时候都想找你来着,但经常想到之前的种种,我就很难过.你说和我说话还没有和朋友聊天开心,说已经慢慢把感情从我身上抽离了,说你比较适合那种会玩的人...你刚开始搬过去住的时候,我还是经常找你,但是你一直回的又很慢,还有2次说看见了忘记给我回了,让我等了半天,后来你又把情侣头像也换了...这一切让我感觉以我在你的世界里已经慢慢变成了多余的,所以想找你的时候然后就会想,你也不是那么想和我聊天吧,想想就算了,就继续做自己的事情了,心里却还是默默的想你,我很矛盾,一方面想找你一方面又觉得你已经那样了,自己找你你也不会怎样
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        let nav = UINavigationController.init(rootViewController: ViewController())
        window?.rootViewController = nav
        
        return true
    }


}

