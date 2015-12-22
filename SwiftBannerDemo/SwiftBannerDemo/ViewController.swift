//
//  ViewController.swift
//  SwiftBannerDemo
//
//  Created by HongPu on 2015/12/22.
//  Copyright © 2015年 tinyxx. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    // IBOutlet
    @IBOutlet weak var bannerTop:    SwiftBanner!
    @IBOutlet weak var bannerMiddle: SwiftBanner!
    // private
    private let warningStr = "Be careful block cycle retain"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // BannerTop
        self.bannerTop.bannerItems = [
            
            BannerItem(imageFetcher: {(imageView) in
            return UIImage(named: "mc1")!
            }, action: {
                print("banner1 press")
        }),
            BannerItem(imageFetcher: {_ in
                return UIImage(named: "mc2")!
                }, action: {
                    print("banner2 press")
            })
        ]
        
        self.bannerTop.timeInterval         = 2.8
        self.bannerTop.autoScrollDirection  = .Left
        
        // BannerMiddle
        weak var weakSelf = self
        self.bannerMiddle.bannerItems = [
            
            BannerItem(imageFetcher: {(imageView) in
                
                let downLoadTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
                dispatch_after(downLoadTime, dispatch_get_main_queue()) {
                    imageView.image = UIImage(named: "img1")
                }
                return UIImage(named: "placeholder")!
                }, action: {
                    print("banner1 press" + weakSelf!.warningStr)
            }),
            BannerItem(imageFetcher: {(imageView) in
                
                let downLoadTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2.2 * Double(NSEC_PER_SEC)))
                dispatch_after(downLoadTime, dispatch_get_main_queue()) {
                    imageView.image = UIImage(named: "img2")
                }
                return UIImage(named: "placeholder")!
                }, action: {
                    print("banner2 press" + weakSelf!.warningStr)
            })
        ]
        
        self.bannerMiddle.timeInterval         = 1.1
        self.bannerMiddle.autoScrollDirection  = .Right
        

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit
    {
        print("ViewController deinit")
    }
}

