//
//  YHControlSlider.swift
//  YHControlSlider
//
//  Created by 郭月辉 on 16/7/11.
//  Copyright © 2016年 Theshy. All rights reserved.
//

import UIKit

enum Orientation: Int {

    case Horizontal  = 0 // 水平
    case Vertical    = 1 // 竖直
}

protocol YHControlSliderDelegate: NSObjectProtocol {
    func yhControlSliderValueChanged(slider: YHControlSlider)
}

class YHControlSlider: UIControl {
        
    var delegate: YHControlSliderDelegate?
    private var _value: CGFloat = 0
    // slide 值
    var value: CGFloat {
        return _value
    }
    // 最小值
    private var minNum: CGFloat = 0
    // 最大值
    private var maxNum: CGFloat = 1
    // 方向
    private var orientation: Orientation = .Horizontal
    // frame
    private var fullFrame: CGRect = CGRect.zero
    // slider Frame
    private var sliderFrame: CGRect = CGRect.zero
    // imageMargin 左右图片距slider间距
    var imageMargin: CGFloat = 5
    
    // 图片半径
    private var radius: CGFloat = 0
    // 中间圆心距两边间距
    private let centerMargin: CGFloat = 2
    // slider 环形宽度
    private let lineWidth: CGFloat = 2
    // 额外点击区域
    private let HANDLE_TOUCH_AREA: CGFloat = -15
    // 传进来的frame 主要为了计算旋转后的位置
    private var oriFrame: CGRect = CGRect.zero
    
    init(frame: CGRect, minNum: CGFloat, maxNum: CGFloat, orientation: Orientation) {
        super.init(frame: frame)
        if maxNum < minNum {
            print("最大值 < 最小值")
            return
        }
        
        self.orientation = orientation
        self.oriFrame = frame
        var newFrame = frame
        newFrame.origin.x = 0
        newFrame.origin.y = 0
        self.fullFrame = newFrame
        self.minNum = minNum
        self.maxNum = maxNum
        self.userInteractionEnabled = true
        
        calcViewFrame()
        setupContent()
        setupOrientation()
    }
    
    private func calcViewFrame() {
        radius = (fullFrame.size.height - 2 * (lineWidth + centerMargin)) * 0.5
        
        var newFrame = fullFrame
        newFrame.size.width = fullFrame.size.width - 2 * (imageMargin + 2 * radius)
        newFrame.origin.x = 2 * radius + imageMargin
        sliderFrame = newFrame
    }
    
    private func setupContent() {
        
        leftImageView.frame = CGRect(x: 0, y: lineWidth + centerMargin, width: 2 * radius, height: 2 * radius)
        leftImageView.contentMode = .ScaleAspectFill
        rightImageView.frame = CGRect(x: fullFrame.size.width - 2 * radius, y: lineWidth + centerMargin, width: 2 * radius, height: 2 * radius)
        rightImageView.contentMode = .ScaleAspectFill
        addSubview(leftImageView)
        addSubview(rightImageView)
        
        setupSliderView()
    }
    
    private func setupSliderView() {
        sliderView.frame = sliderFrame
        addSubview(sliderView)
        sliderView.userInteractionEnabled = false
        sliderView.layer.cornerRadius = fullFrame.size.height * 0.5
        sliderView.layer.masksToBounds = true
        sliderView.layer.borderWidth = lineWidth
        sliderView.layer.borderColor = UIColor.whiteColor().CGColor
        
        controlView.backgroundColor = UIColor.whiteColor()
        controlView.userInteractionEnabled = false
        controlView.layer.cornerRadius = radius
        controlView.layer.masksToBounds = true
        sliderView.addSubview(controlView)
        controlView.frame = CGRect(x: lineWidth + centerMargin, y: lineWidth + centerMargin, width: 2 * radius, height: 2 * radius)
    }
    
    /// 只做了 x,y方向上的转换   width和height没做变化   默认方向是水平 竖直则旋转
    private func setupOrientation() {
        if orientation == .Vertical {
            let ttx = (oriFrame.size.width - oriFrame.size.height) * 0.5
            let tty = (oriFrame.size.width - oriFrame.size.height) * 0.5
            transform = CGAffineTransformMake(1, 0, 0, 1, -ttx, tty)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
            leftImageView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
            rightImageView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        }
    }

    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        
        let touchPoint: CGPoint = touch.locationInView(self.sliderView)
        if CGRectContainsPoint(CGRectInset(self.controlView.frame,HANDLE_TOUCH_AREA, 0), touchPoint) {
            refreshSlider(touchPoint)
            return true
        }
        return false
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let touchPoint: CGPoint = touch.locationInView(self.sliderView)
        if CGRectContainsPoint(CGRectInset(self.controlView.frame,HANDLE_TOUCH_AREA, 0), touchPoint) {
            refreshSlider(touchPoint)
            return true
        }
        return false
        
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        
        guard let touchPoint: CGPoint = touch!.locationInView(self.sliderView) else {
            return
        }
        if CGRectContainsPoint(CGRectInset(self.controlView.frame,HANDLE_TOUCH_AREA, 0), touchPoint) {
            refreshSlider(touchPoint)
            
        }
    }
    
    
    // MARK: - 更新label
    private func refreshSlider(point: CGPoint) {
        
        let beginX = lineWidth + imageMargin + radius
        var touchPoint: CGPoint = point
        if touchPoint.x < beginX {touchPoint.x = beginX}
        if touchPoint.x > sliderFrame.width - beginX {
            touchPoint.x = sliderFrame.width - beginX
        }
        
        var newFrame: CGRect = self.controlView.frame
        newFrame.origin.x = touchPoint.x - radius
        self.controlView.frame = newFrame
        
        _value = minNum + ((touchPoint.x - beginX)/(sliderFrame.width - 2 * beginX)) * (maxNum - minNum)
        delegate?.yhControlSliderValueChanged(self)
        
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var leftImageView = UIImageView()
    lazy var rightImageView = UIImageView()
    private lazy var sliderView: UIView = UIView()
    private lazy var controlView: UIView = UIView()
    
}
