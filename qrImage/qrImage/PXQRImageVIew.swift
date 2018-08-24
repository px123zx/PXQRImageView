//
//  PXQRImageVIew.swift
//  qrImage
//
//  Created by Paxton on 2018/8/24.
//  Copyright © 2018年 px. All rights reserved.
//

import UIKit

class PXQRImageVIew: UIImageView {

    private var backImgeView: UIImageView?
    private var QRImg: UIImage?
    var backImgScale: CGFloat = 0.5 {
        didSet {
            
            if backImgScale > 1 {
                backImgScale = 1
            }
            backImgeView?.frame = CGRect(x: 0, y: 0, width: self.bounds.width * backImgScale, height: self.bounds.width * backImgScale)
        }
    }
    
    
    
    convenience init(frame: CGRect, qrStr: String, backImg: UIImage?) {
        self.init(frame: frame)
        QRImg = generateCode(inputMsg: qrStr)
        self.image = QRImg
        if let backImg = backImg {
            let maskImg = genQRCodeImageMask(grayScaleQRCodeImage: QRImg)
            let maskLayer = CALayer()
            maskLayer.contents = maskImg
            maskLayer.frame = self.bounds
            
            backImgeView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width * backImgScale, height: self.bounds.width * backImgScale))
            backImgeView?.center = CGPoint(x: self.bounds.width/2, y: self.bounds.width/2)
            backImgeView?.image = backImg
            backImgeView?.backgroundColor = UIColor.black
            self.addSubview(backImgeView!)
            backImgeView?.layer.mask = maskLayer
        }
    }
    
    //设置二维码图
    func setQRImg(_ qrStr: String){
        let qrImg = generateCode(inputMsg: qrStr)
        self.image = qrImg
        QRImg = qrImg
    }
    
    //设置背景图
    func setBackImg(_ img: UIImage){
        if let backImgeView = backImgeView {
            backImgeView.image = img
        }else{
            if QRImg == nil {
                return
            }
            let maskImg = genQRCodeImageMask(grayScaleQRCodeImage: QRImg)
            let maskLayer = CALayer()
            maskLayer.contents = maskImg
            maskLayer.frame = self.bounds
            
            backImgeView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width * backImgScale, height: self.bounds.width * backImgScale))
            backImgeView?.center = CGPoint(x: self.bounds.width/2, y: self.bounds.width/2)
            backImgeView?.image = img
            backImgeView?.backgroundColor = UIColor.black
            self.addSubview(backImgeView!)
            backImgeView?.layer.mask = maskLayer
        }
    }
    
    
    /* *  @param inputMsg 二维码保存的信息
     */
    private func generateCode(inputMsg: String ) -> UIImage {
        //1. 将内容生成二维码
        //1.1 创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        //1.2 恢复默认设置
        filter?.setDefaults()
        
        //1.3 设置生成的二维码的容错率
        //value = @"L/M/Q/H"
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        // 2.设置输入的内容(KVC)
        // 注意:key = inputMessage, value必须是NSData类型
        let inputData = inputMsg.data(using: .utf8)
        filter?.setValue(inputData, forKey: "inputMessage")
        
        //3. 获取输出的图片
        guard let outImage = filter?.outputImage else { return UIImage() }
        
        //4. 获取高清图片
        let hdImage = getHDImage(outImage)
        
        return hdImage
    }
    
    //高清图
    private func getHDImage(_ outImage: CIImage) -> UIImage {
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        //放大图片
        let ciImage = outImage.transformed(by: transform)
        
        return UIImage(ciImage: ciImage)
    }
    
    private func genQRCodeImageMask(grayScaleQRCodeImage: UIImage?) -> CGImage? {
        if let image = grayScaleQRCodeImage {
            let bitsPerComponent = 8
            let bytesPerPixel = 4
            let width:Int = Int(image.size.width)
            let height:Int = Int(image.size.height)
            let imageData = UnsafeMutableRawPointer.allocate(byteCount: Int(width * height * bytesPerPixel), alignment: 8)
            
            // 将原始黑白二维码图片绘制到像素格式为ARGB的图片上，绘制后的像素数据在imageData中。
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let imageContext = CGContext.init(data: imageData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: bitsPerComponent, bytesPerRow: width * bytesPerPixel, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue )
            UIGraphicsPushContext(imageContext!)
            imageContext?.translateBy(x: 0, y: CGFloat(height))
            imageContext?.scaleBy(x: 1, y: -1)
            image.draw(in: CGRect.init(x: 0, y: 0, width: width, height: height))
            UIGraphicsPopContext()
            
            // 根据每个像素R通道的值修改Alpha通道的值，当Red大于100，则将Alpha置为0，反之置为255
            for row in 0..<height {
                for col in 0..<width {
                    let offset = row * width * bytesPerPixel + col * bytesPerPixel
                    let r = imageData.load(fromByteOffset: offset + 1, as: UInt8.self)
                    let alpha:UInt8 = r > 100 ? 0 : 255
                    imageData.storeBytes(of: alpha, toByteOffset: offset, as: UInt8.self)
                }
            }
            
            return imageContext?.makeImage()
        }
        return nil
    }
    
}
