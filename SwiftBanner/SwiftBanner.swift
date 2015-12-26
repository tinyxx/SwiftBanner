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
    public let imageFetcher: ((UIImageView) -> UIImage?)
    public let action: (() -> ())?
}

// MARK: - enum
public enum AutoScrollDirection
{
    case None
    case Left
    case Right
}

public enum PageControlPosition
{
    case None
    case Left
    case Right
    case Middle
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
    
    public var autoScrollDirection = AutoScrollDirection.Right
    public var pageControlPosition = PageControlPosition.Middle
    
    // MARK: - private var
    private var onceTicken: dispatch_once_t = 0
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
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
    
    public override func layoutSubviews()
    {
        super.layoutSubviews()
        self.updateSubViews(self.bannerItems)
        // against navigation viewcontroller adjust scrollview inset
        self.scrollView.contentInset = UIEdgeInsetsZero
    }
    
    // MARK: - UIScrollViewDelegate
    public func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        self.stopTimer()
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        self.checkScrollBorder()
        self.updatePageControlHint()
    }
    
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView)
    {
        self.checkScrollBorder()
        self.updatePageControlHint()
    }
    
    // MARK: - private method
    private func updateSubViews(bannerItems: [BannerItem])
    {
        if bannerItems.count < 1
        {
            return
        }

        self.updateScrollView(bannerItems)
        self.updatePageControl(bannerItems)
        
        self.currentIndex = 1
        self.fireTimer()
        
        dispatch_once(&self.onceTicken, {
            self.scrollView.pagingEnabled = true
            self.scrollView.delegate = self
            self.scrollView.showsHorizontalScrollIndicator = false
            self.scrollView.showsVerticalScrollIndicator = false
            
            self.addSubview(self.scrollView)
            self.addSubview(self.pageControl)
        })
    }
    
    private func updateScrollView(bannerItems: [BannerItem])
    {
        for view in self.scrollView.subviews
        {
            view.removeFromSuperview()
        }
        
        for (index, item) in bannerItems.enumerate()
        {
            self.scrollView.addSubview({
                
                let itemView = UIControl(frame: CGRectMake(CGFloat(index) * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height))
                itemView.tag = index
                itemView.addTarget(self, action: Selector("hitAction:"), forControlEvents: .TouchUpInside)
                
                itemView.addSubview({
                    
                    let imageView = UIImageView(frame: CGRectMake(0, 0, itemView.frame.size.width, itemView.frame.size.height))
                    dispatch_async_main_queue({
                        imageView.image = item.imageFetcher(imageView)
                    })
                    
                    return imageView
                    }())
                
                return itemView
                }())
        }
        
        if self.bannerItems.count > 3
        {
            self.scrollView.addSubview({
                
                let firstItem = self.bannerItems[self.bannerItems.count - 3]
                let itemView = UIControl(frame: CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height))
                itemView.addSubview({
                    
                    let imageView = UIImageView(frame: CGRectMake(0, 0, itemView.frame.size.width, itemView.frame.size.height))
                    dispatch_async_main_queue({
                        imageView.image = firstItem.imageFetcher(imageView)
                    })
                    
                    return imageView
                    }())
                
                return itemView
                }())
            
            self.scrollView.addSubview({
                
                let lastItem = self.bannerItems[2]
                let itemView = UIControl(frame: CGRectMake(CGFloat(self.bannerItems.count) * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height))
                itemView.addSubview({
                    
                    let imageView = UIImageView(frame: CGRectMake(0, 0, itemView.frame.size.width, itemView.frame.size.height))
                    dispatch_async_main_queue({
                        imageView.image = lastItem.imageFetcher(imageView)
                    })
                    
                    return imageView
                    }())
                
                return itemView
                }())
        }
        
        self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.scrollView.contentSize = CGSizeMake(CGFloat(bannerItems.count) * self.frame.size.width, self.frame.size.height)
    }
    
    private func updatePageControl(bannerItems: [BannerItem])
    {
        if bannerItems.count > 2
        {
            self.pageControl.numberOfPages = bannerItems.count - 2
        }
        else
        {
            self.pageControl.numberOfPages = bannerItems.count
        }
        
        let marginX: CGFloat = 10
        
        let marginY: CGFloat = -6
        let size = self.pageControl.sizeForNumberOfPages(self.pageControl.numberOfPages)
        
        var x: CGFloat = 0
        switch self.pageControlPosition
        {
        case .None:
            self.pageControl.hidden = true
            
        case .Left:
            x = marginX
            self.pageControl.hidden = false
            
        case .Right:
            x = self.frame.size.width - size.width - marginX
            self.pageControl.hidden = false
          
        case .Middle:
            x = (self.frame.size.width - size.width) / 2
            self.pageControl.hidden = false
        }
        
        self.pageControl.frame = CGRectMake(x, self.frame.size.height - marginY - size.height, size.width, size.height)
    }
    
    private func updatePageControlHint()
    {
        if self.bannerItems.count < 2
        {
            self.pageControl.currentPage = self.currentIndex
        }
        else
        {
            self.pageControl.currentPage = self.currentIndex - 1
        }
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
        
        self.timer = NSTimer(timeInterval: NSTimeInterval(self.timeInterval), target: WeakTarget(target: self).target!, selector: Selector("autoScroll"), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
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
        switch self.autoScrollDirection
        {
        case .None:
            break
            
        case .Left:
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x - self.frame.size.width, y: 0), animated: true)
            
        case .Right:
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x + self.frame.size.width, y: 0), animated: true)
        }
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

// MARK: - dispatch_async_main_queue
func dispatch_async_main_queue(block: dispatch_block_t)
{
    if NSThread.isMainThread()
    {
        block()
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), block)
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
