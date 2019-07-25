//
//  ViewController.swift
//  YWBubbleViewDemo
//
//  Created by Dyw on 2019/7/25.
//  Copyright © 2019 amez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var bubbleWindow : YWBubbleWindow?
    var bubbleView : YWBubbleView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /// YWBubbleWindow ------------------------
        let view1 = UIImageView(image: UIImage(named: "img1"))
        bubbleWindow = YWBubbleWindow(customView: view1, margin: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), level: UIWindow.Level.alert+1,backBlock: {[weak self] in
            guard let strongSelf =  self else{
                return
            }
            strongSelf.showAlt()
        })
        bubbleWindow?.show()
        bubbleWindow?.position = .Right
        bubbleWindow?.positionY = 900
        
        /// YWBubbleWindow ------------------------
        let view2 = UIImageView(image: UIImage(named: "img2"))
        bubbleView = YWBubbleView(customView: view2, margin: UIEdgeInsets.zero, backBlock: {[weak self] in
            guard let strongSelf =  self else{
                return
            }
            strongSelf.showAlt()
        })
        bubbleView?.show(atView: view)
        bubbleView?.position = .Right
        bubbleView?.positionY = 100
    }

    func showAlt() {
        let alt = UIAlertController(title: "切换环境", message: "随便怎么切换", preferredStyle: UIAlertController.Style.alert)
        
        alt.addAction(UIAlertAction(title: "开心就好", style: UIAlertAction.Style.cancel, handler: {[weak self] (action) in
            guard let strongSelf =  self else{
                return
            }
            print("气泡\(strongSelf.bubbleWindow.debugDescription)")
        }))
        present(alt, animated: true, completion: nil)
    }
}

