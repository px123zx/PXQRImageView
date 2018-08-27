# PXQRImageView
带背景、logo的二维码框

## 使用
### 直接初始化

``` swift
    /// 初始化
    ///
    /// - Parameters:
    ///   - frame: 二维码位置， 宽高需要一样、不一样是以宽度为准
    ///   - qrStr: 二维码信息
    ///   - backImg: 背景或logo图
    PXQRImageVIew(frame: CGRect, qrStr: String, backImg: UIImage?)
```
### 初始化后设置
``` swift
let qrView = PXQRImageVIew(frame: CGRect)
//设置二维码图
qrView.setQRImg("www.123.com")
//设置背景图
qrView.setBackImg(UIImage(named: "q")!)
//设置背景图所占比例
qrView.backImgScale = 1
``` 
### 效果图
![-w230](media/15353326060072/15353337529337.jpg)
