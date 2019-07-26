//
//  YWBubbleView.swift
//  YWBubbleViewDemo
//
//  Created by Dyw on 2019/7/25.
//  Copyright © 2019 amez. All rights reserved.
//

import UIKit

private let YWKeyWindow = UIApplication.shared.windows[0]

public enum YWBubblePosition {
    case Left
    case Right
}

public class YWBubbleView: UIView {
    
    private var contentView : UIView?
    private var marginInsets = UIEdgeInsets.zero
    private var tapBlock : (()->Void)?
    
    var position = YWBubblePosition.Left {
        didSet{
            updatePosition()
        }
    }
    var positionY : CGFloat = 0.0{
        didSet{
            updatePosition()
        }
    }
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - customView: 要显示的View
    ///   - margin: 外边距
    ///   - backBlock: 点击回调
    init(customView: UIView, margin:UIEdgeInsets?, backBlock:(()->Void)?) {
        super.init(frame: customView.bounds)
        if margin != nil {
            marginInsets = margin!
        }
        tapBlock = backBlock
        center = CGPoint(x: marginInsets.left+frame.size.width*0.5, y: marginInsets.top+frame.size.height*0.5)
        backgroundColor = UIColor.clear
        self.contentView = customView
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEvent))
        addGestureRecognizer(tap)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panEvent))
        addGestureRecognizer(pan)
        hidden()
        addSubview(customView)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(atView:UIView) {
        atView.addSubview(self)
    }
    
    func hidden() {
        removeFromSuperview()
    }
    
    @objc func tapEvent() {
        tapBlock?()
    }
    
    @objc func panEvent(pan:UIPanGestureRecognizer) {
        let point = pan.location(in: self)
        locationChange(point: point)
        if pan.state == UIGestureRecognizer.State.ended {
            locationChangeEnded()
        }
    }
    
    private func locationChange(point:CGPoint) {
        guard superview != nil else {
            return
        }
        var newCenter = CGPoint(x: center.x+point.x-bounds.size.width*0.5, y: center.y+point.y-bounds.size.height*0.5)
        newCenter.y = max(bounds.size.height*0.5+marginInsets.top, newCenter.y)
        newCenter.y = min(superview!.bounds.size.height-bounds.size.height*0.5-marginInsets.bottom, newCenter.y)
        newCenter.x = max(bounds.size.width*0.5+marginInsets.left, newCenter.x)
        newCenter.x = min(superview!.bounds.size.width-bounds.size.width*0.5-marginInsets.right, newCenter.x)
        center = newCenter;
    }
    
    func locationChangeEnded() {
        guard superview != nil else {
            return
        }
        var curentCenter = center
        if curentCenter.x > superview!.bounds.size.width*0.5 {
            curentCenter.x = superview!.bounds.size.width-bounds.size.width*0.5-marginInsets.right
        }else{
            curentCenter.x = bounds.size.width*0.5+marginInsets.left
        }
        UIView.animate(withDuration: 0.25) {
            self.center = curentCenter
        }
    }
    
    func updatePosition() {
        guard superview != nil else {
            return
        }
        var curentCenter = center
        if position == .Right {
            curentCenter.x = superview!.bounds.size.width-bounds.size.width*0.5-marginInsets.right
        }else{
            curentCenter.x = bounds.size.width*0.5+marginInsets.left
        }
        let superViewHeight = superview!.bounds.height
        if positionY + bounds.size.height*0.5 + marginInsets.bottom > superViewHeight {
            curentCenter.y = superViewHeight - bounds.size.height*0.5 - marginInsets.bottom
        }else if positionY + bounds.size.height*0.5  < marginInsets.top{
            curentCenter.y = marginInsets.top
        }else{
            curentCenter.y = positionY + bounds.size.height*0.5 + marginInsets.top
        }
        self.center = curentCenter
    }
}

public class YWBubbleWindow: UIWindow {

    private var contentView : UIView?
    private var marginInsets = UIEdgeInsets.zero
    private var tapBlock : (()->Void)?
    
    var position = YWBubblePosition.Left {
        didSet{
            updatePosition()
        }
    }
    var positionY : CGFloat = 0.0{
        didSet{
            updatePosition()
        }
    }
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - customView: 要显示的View
    ///   - margin: 外边距
    ///   - backBlock: 点击回调
    init(customView: UIView, margin:UIEdgeInsets?, level:UIWindow.Level,backBlock:(()->Void)?) {
        super.init(frame: customView.bounds)
        if margin != nil {
            marginInsets = margin!
        }
        tapBlock = backBlock
        center = CGPoint(x: curentAreaInsets.left+frame.size.width*0.5, y: curentAreaInsets.top+frame.size.height*0.5)
        backgroundColor = UIColor.clear
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.clear
        rootViewController = vc
        self.contentView = customView
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEvent))
        addGestureRecognizer(tap)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panEvent))
        addGestureRecognizer(pan)
        windowLevel = level
        makeKeyAndVisible()
        YWKeyWindow.makeKeyAndVisible()
        hidden()
        vc.view.addSubview(customView)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        self.isHidden = false
    }
    
    func hidden() {
        self.isHidden = true
    }
    
    @objc func tapEvent() {
        tapBlock?()
    }

    @objc func panEvent(pan:UIPanGestureRecognizer) {
        let point = pan.location(in: self)
        locationChange(point: point)
        if pan.state == UIGestureRecognizer.State.ended {
            locationChangeEnded()
        }
    }
    
    private func locationChange(point:CGPoint) {
        var newCenter = CGPoint(x: center.x+point.x-bounds.size.width*0.5, y: center.y+point.y-bounds.size.height*0.5)
        newCenter.y = max(bounds.size.height*0.5+curentAreaInsets.top, newCenter.y)
        newCenter.y = min(YWKeyWindow.bounds.size.height-bounds.size.height*0.5-curentAreaInsets.bottom, newCenter.y)
        newCenter.x = max(bounds.size.width*0.5+curentAreaInsets.left, newCenter.x)
        newCenter.x = min(YWKeyWindow.bounds.size.width-bounds.size.width*0.5-curentAreaInsets.right, newCenter.x)
        center = newCenter;
//        print("\n手指位置--->\(point) \n气泡中心--->\(center) \n当前安全偏移--->\(curentAreaInsets) \nKeyWindow--->\(YWKeyWindow.bounds) \n气泡大小--->\(bounds) \n结果--->\(newCenter)")
    }
    
    func locationChangeEnded() {
        var curentCenter = center
        if curentCenter.x > YWKeyWindow.bounds.size.width*0.5 {
            curentCenter.x = YWKeyWindow.bounds.size.width-bounds.size.width*0.5-curentAreaInsets.right
        }else{
            curentCenter.x = bounds.size.width*0.5+curentAreaInsets.left
        }
        UIView.animate(withDuration: 0.25) {
            self.center = curentCenter
        }
    }
    
    func updatePosition() {
        var curentCenter = center
        if position == .Right {
            curentCenter.x = YWKeyWindow.bounds.size.width-bounds.size.width*0.5-curentAreaInsets.right
        }else{
            curentCenter.x = bounds.size.width*0.5+curentAreaInsets.left
        }
        let superViewHeight = YWKeyWindow.bounds.height
        if positionY + bounds.size.height*0.5 + curentAreaInsets.bottom > superViewHeight {
            curentCenter.y = superViewHeight - bounds.size.height*0.5 - curentAreaInsets.bottom
        }else if positionY + bounds.size.height*0.5  < curentAreaInsets.top{
            curentCenter.y = curentAreaInsets.top
        }else{
            curentCenter.y = positionY + bounds.size.height*0.5 + curentAreaInsets.top
        }
        self.center = curentCenter
    }
    
    private var curentAreaInsets : UIEdgeInsets{
        var insets = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            insets = YWKeyWindow.safeAreaInsets
        }
        insets.top = max(insets.top, 20)
        return UIEdgeInsets(top: insets.top + marginInsets.top, left: insets.left + marginInsets.left, bottom: insets.bottom + marginInsets.bottom, right: insets.right + marginInsets.right)
    }
    
    private func isiPhoneXScreen() -> Bool {
        guard #available(iOS 11.0, *) else {
            return false
        }
        return YWKeyWindow.safeAreaInsets != UIEdgeInsets.zero
    }
}
