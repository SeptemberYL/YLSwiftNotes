//
//  PopStateConfig.swift
//  Demo
//
//  Created by lin on 2025/3/27.
//

import UIKit

/// 弹窗配置
public struct PopStateConfig {
    //MARK: - 背景相关
    /// 是否阻拦点击事件(仅loading窗口生效)
    var isUnableClick : Bool = false
    /// 背景色
    var backColor : UIColor = .clear
    
    //MARK: - 弹窗相关
    /// 弹窗最小尺寸
    var hudMinSize : CGSize = CGSize(width: 240, height: 150)
    /// 弹窗最大尺寸
    var hudMaxSize : CGSize = CGSize(width: 300, height: 500)
    /// 弹窗底色
    var hudBackColor : UIColor = .black.withAlphaComponent(0.7)
    /// 弹窗圆角
    var hudLayerRadius : CGFloat = 8
    /// 仅展示文字时最小尺寸(默认与其他状态一致)
    var onlyTipsHudMinxSize : CGSize?
    /// 仅展示文字时最大尺寸(默认与其他状态一致)
    var onlyTipsHudMaxSize : CGSize?
    /// 仅展示文字时底色(默认与其他状态一致)
    var onlyTipsHudBackColor : UIColor?
    
    //MARK: - 图片相关
    /// 加载图片
    var loadingImage : UIImage?
    /// 加载图片尺寸(成功与失败不设置尺寸的话默认一致)
    var loadingSize : CGSize = CGSize(width: 40, height: 40)
    /// 旋转一圈时长 为0就是不旋转
    var loadingRotateDuration : TimeInterval = 1
    /// 成功图片
    var successImage : UIImage?
    /// 成功图片尺寸 不设置尺寸默认与加载一致
    var successSize : CGSize?
    /// 失败图片
    var failImage : UIImage?
    /// 失败图片尺寸 不设置尺寸默认与加载一致
    var failSize : CGSize?
    /// 图片间距(距上,左右为0的话居中,下不生效,在文本间距设置)
    var imageEdgs : UIEdgeInsets = .init(top: 32, left: 0, bottom: 0, right: 0)
    
    //MARK: - 文本相关
    /// 提示语字体大小
    var tipsFont : UIFont = .systemFont(ofSize: 18, weight: .regular)
    /// 提示语颜色
    var tipsColor : UIColor = .white
    /// 提示语多少行
    var tipsNumberOfLines : Int = 0 // 默认自动换行
    /// 提示语间距
    var tipsEdgs : UIEdgeInsets = .init(top: 8, left: 16, bottom: 8, right: 16)
    /// 仅文字时字体大小(默认与tipsFont一致)
    var onlyTipsFont : UIFont?
    /// 仅文字时字体大小(默认与tipsColor一致)
    var onlyTipsColor : UIColor?
    /// 仅文字时间距(默认与tipsEdgs一致)
    var onlyTipsEdgs : UIEdgeInsets?
    
    //MARK: - 关闭按钮
    /// 是否展示关闭按钮
    var isShowExit : Bool = false
    /// 关闭按钮图片
    var exitImage : UIImage?
    /// 关闭按钮尺寸
    var exitImageSize : CGSize = CGSize(width: 32, height: 32)
    /// 关闭按钮间距
    var exitEdgs : UIEdgeInsets = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 16)
    
    //MARK: - 动画相关
    /// 是否需要动画
    var isDismissAnimate : Bool = true
    /// 提示框停留多少秒
    var hudDismissDelay : TimeInterval = 1.5
    /// 提示框淡入淡出动画时长
    var hudDissmissAnimateDuration : TimeInterval = 0.3
    /// 仅展示文字时停留多少秒 默认与hudDismissDelay一致
    var onlyTipsDismissDelay : TimeInterval?
    /// 仅展示文字时动画多少秒 默认与hudDissmissAnimateDuraiton一致
    var onlyTipsDissmissAnimateDuraiton : TimeInterval?
    
    //MARK: - Banner配置
    /// banner动画时长
    var bannerAnimateDuration : TimeInterval = 0.3
    /// banner停留多少秒
    var bannerAnimateDelay : TimeInterval = 1.5
    /// banner底色
    var bannerBackColor : UIColor = .black.withAlphaComponent(0.7)
    /// banner圆角
    var bannerLayerRadius : CGFloat = 8
    /// banner尺寸
    var bannerHeight : CGFloat = 68
    /// banner底板间距(上下仅同时生效一个,下就为居下, 上优先级较高)
    var bannerEdgs : UIEdgeInsets = .init(top: 44.0 + 20, left: 50, bottom: 0, right: 50)
    /// banner文字间距(生效左右,上下居中,tips文本最大高度为bannersize - edgs.top - edgs.bottom)
    var bannerTipsEdgs : UIEdgeInsets = .init(top: 8, left: 12, bottom: 8, right: 12)
    /// 提示语字体
    var bannerTipsFont : UIFont = .systemFont(ofSize: 18, weight: .regular)
    /// 提示语文字颜色
    var bannerTipsColor : UIColor = .white
}
