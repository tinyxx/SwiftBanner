# SwiftBanner

A Cycle Banner by Swift

## Usage

It is quite easy to use, loading image from local:

``` objc
let banner = SwiftBanner()
banner.bannerItems = [
            BannerItem(imageFetcher: {(imageView) in
            return UIImage(named: "imageName")!
            }, action: {
                print("banner1 press")
        }),
            BannerItem(imageFetcher: {_ in
                return UIImage(named: "imageName")!
                }, action: {
                    print("banner2 press")
            })
        ]
        
        banner.timeInterval         = 2.8
        banner.autoScrollDirection  = .Left
```

loading image from network:

``` objc
let banner = SwiftBanner()
banner.bannerItems = [
            BannerItem(imageFetcher: {(imageView) in
                let imageFormNetwork = UIImage() // loading image form network
                imageView.image = imageFormNetwork
                return UIImage(named: "placeholder")!
                }, action: {
                    print("banner1 press")
            }),
            BannerItem(imageFetcher: {(imageView) in
                let imageFormNetwork = UIImage() // loading image form network
                imageView.image = imageFormNetwork
                return UIImage(named: "placeholder")!
                }, action: {
                    print("banner2 press")
            })
        ]
        
        banner.timeInterval         = 2.8
        banner.autoScrollDirection  = .Left
```

For more infomation, please check the demo project, Thanks!



## License

MIT LICENSE
