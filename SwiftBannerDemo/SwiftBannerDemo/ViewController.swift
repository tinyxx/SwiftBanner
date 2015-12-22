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
    @IBOutlet weak var bannerTop: SwiftBanner!
    // private
    private let warningStr = "Be careful block cycle retain"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //        weak var weakSelf = self
        
        // BannerTop
        self.bannerTop.bannerItems = [BannerItem(imageFetcher: {(imageView) in
            
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
        
        self.bannerTop.direction = .Left
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

