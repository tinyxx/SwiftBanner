//
//  ViewController.swift
//  SwiftBanner
//
//  Created by HongPu on 2015/12/17.
//  Copyright © 2015年 tinyxx. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var banner: SwiftBanner!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.banner.frame = CGRectMake(0, 0, 320, 160)
        self.banner.bannerItems = [BannerItem(image: UIImage(named: "mc1")!, action: {
            print("1111 press")
        }), BannerItem(image: UIImage(named: "mc2")!, action: {
            print("2222 press")
        })]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

