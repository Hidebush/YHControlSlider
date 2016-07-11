//
//  ViewController.swift
//  YHControlSlider
//
//  Created by 郭月辉 on 16/7/11.
//  Copyright © 2016年 Theshy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, YHControlSliderDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.greenColor()
        
        let sil = YHControlSlider(frame: CGRect(x: 30, y: 100, width: 200, height: 30), minNum: 10, maxNum: 60, orientation: .Horizontal)
        sil.delegate = self
        sil.leftImageView.image = UIImage(named: "battery")
        sil.rightImageView.image = UIImage(named: "camera")
        view.addSubview(sil)
        
        
        
        
        /// 只做了 x,y方向上的转换   width和height没做变化   默认方向是水平 竖直则旋转
        let sil1 = YHControlSlider(frame: CGRect(x: 100, y: 250, width: 200, height: 30), minNum: 10, maxNum: 60, orientation: .Vertical)
        sil1.delegate = self
        sil1.leftImageView.image = UIImage(named: "battery")
        sil1.rightImageView.image = UIImage(named: "camera")
        view.addSubview(sil1)
        
    }
    
    func yhControlSliderValueChanged(slider: YHControlSlider) {
        print(slider.value)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

