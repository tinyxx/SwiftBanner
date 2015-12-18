//
//  SwiftBanner.swift
//  SwiftBanner
//
//  Created by HongPu on 2015/12/17.
//  Copyright © 2015年 tinyxx. All rights reserved.
//

import UIKit

// MARK: - BannerItem
public struct BannerItem
{
    public let image: UIImage
    public let action: (() -> ())?
}

// MARK: - Direction enum
public enum AutoScrollDirection
{
    case Left
    case Right
}

// MARK: - SwiftBanner
public class SwiftBanner: UIView, UIScrollViewDelegate
{
    // MARK: - public var
    public var bannerItems = [BannerItem](){
        didSet{
            
            if self.bannerItems.count > 1
            {
                let firstItem = self.bannerItems[0]
                let lastItem = self.bannerItems[self.bannerItems.count - 1]
                self.bannerItems.append(firstItem)
                self.bannerItems.insert(lastItem, atIndex: 0)
            }

            self.updateSubViews(self.bannerItems)
        }
    }
    
    public var timeInterval = Float(3){
        
        didSet{
            self.fireTimer()
        }
    }
    
    public var direction = AutoScrollDirection.Right
    
    // MARK: - private var
    private static var onceTicken: dispatch_once_t = 0
    private let scrollView = UIScrollView()
    private var timer: NSTimer?
    private var currentIndex: Int{
        get{
            return Int(self.scrollView.contentOffset.x / self.frame.size.width)
        }
        
        set{
            self.scrollView.setContentOffset(CGPointMake(CGFloat(newValue) * self.frame.size.width, 0), animated: false)
        }
    }
    
    // MARK: - default
    deinit
    {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // MARK: - UIScrollViewDelegate
    public func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        self.stopTimer()
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        self.checkScrollBorder()
    }
    
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView)
    {
        self.checkScrollBorder()
    }
    
    // MARK: - private method
    private func updateSubViews(bannerItems: [BannerItem])
    {
        for view in self.scrollView.subviews
        {
            view.removeFromSuperview()
        }
        
        if bannerItems.count == 0
        {
            return
        }
        
        for (index, item) in bannerItems.enumerate()
        {
            let itemView = UIControl(frame: CGRectMake(CGFloat(index) * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height))
            itemView.backgroundColor = UIColor(patternImage: item.image)
            itemView.tag = index
            itemView.addTarget(self, action: Selector("hitAction:"), forControlEvents: .TouchUpInside)
            
            self.scrollView.addSubview(itemView)
        }
        
        if self.bannerItems.count > 1
        {
            self.scrollView.addSubview({
                
                let firstItem = self.bannerItems[1]
                let itemView = UIControl(frame: CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height))
                itemView.backgroundColor = UIColor(patternImage: firstItem.image)
                return itemView
                }())
            
            self.scrollView.addSubview({
                
                let lastItem = self.bannerItems[self.bannerItems.count - 2]
                let itemView = UIControl(frame: CGRectMake(CGFloat(self.bannerItems.count) * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height))
                itemView.backgroundColor = UIColor(patternImage: lastItem.image)
                return itemView
                }())
        }
        
        self.scrollView.contentSize = CGSizeMake(CGFloat(bannerItems.count) * self.frame.size.width, self.frame.size.height)
        self.fireTimer()
        
        dispatch_once(&SwiftBanner.onceTicken, {
            self.scrollView.pagingEnabled = true
            self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
            self.scrollView.delegate = self
            self.currentIndex = 1
            
            self.addSubview(self.scrollView)
        })
    }
    
    @objc private func hitAction(sender: AnyObject)
    {
        if let view = sender as? UIControl where view.tag < self.bannerItems.count
        {
            self.bannerItems[view.tag].action?()
        }
    }
    
    // MARK: - timer
    private func fireTimer()
    {
        self.timer?.invalidate()
        self.timer = nil
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(self.timeInterval), target: WeakTarget(target: self).target!, selector: Selector("autoScroll"), userInfo: nil, repeats: true)
    }
    
    private func stopTimer()
    {
        self.timer?.invalidate()
    }
    
    private func refrushTimer()
    {
        if let valid = self.timer?.valid where !valid
        {
            self.fireTimer()
        }
    }
    
    // auto Scroll
    @objc private func autoScroll()
    {
        var x = CGFloat(0)
        switch self.direction
        {
        case .Left:
            x = self.scrollView.contentOffset.x - self.frame.size.width
            
        case .Right:
            x = self.scrollView.contentOffset.x + self.frame.size.width
        }
        
        self.scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    
    // endless Scroll
    private func checkScrollBorder()
    {
        if self.bannerItems.count > 1
        {
            if currentIndex == 0
            {
                self.currentIndex = self.bannerItems.count - 2
            }
            else if currentIndex == self.bannerItems.count - 1
            {
                self.currentIndex = 1
            }
            
            self.refrushTimer()
        }
    }
}

// MARK: - WeakTarget
private class WeakTarget<T: AnyObject>
{
    weak var target: T?
    
    init(target: T?)
    {
        self.target = target
    }
}
