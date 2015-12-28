[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/SwiftBanner.svg)](https://img.shields.io/cocoapods/v/SwiftBanner.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/SwiftBanner.svg?style=flat)](http://cocoadocs.org/docsets/SwiftBanner)

# SwiftBanner

A Cycle Banner by Swift

## Requirements
iOS8 or higher

## Installations

CocoaPods:
```
pod 'SwiftBanner'
```
Carthage:
```
github "tinyxx/SwiftBanner"
```

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
        banner.pageControlPosition  = .Left
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
        banner.autoScrollDirection  = .Right
        banner.pageControlPosition  = .Right
```

For more infomation, please check the demo project, Thanks!



## License

MIT LICENSE
