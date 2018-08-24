//
//  ViewController.swift
//  qrImage
//
//  Created by Paxton on 2018/8/24.
//  Copyright © 2018年 px. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logoView: PXQRImageVIew!
    @IBOutlet weak var bacView: PXQRImageVIew!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoView.setQRImg("www.123.com")
        logoView.setBackImg(UIImage(named: "logo")!)
        
        bacView.setQRImg("www.123.com")
        bacView.setBackImg(UIImage(named: "q")!)
        bacView.backImgScale = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

