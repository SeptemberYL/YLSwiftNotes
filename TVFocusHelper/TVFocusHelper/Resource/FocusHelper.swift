//
//  FocusHelper.swift
//  TVFocusHelper
//
//  Created by lin on 2025/2/14.
//

import UIKit

/// 焦点工具类
class FocusHelper : NSObject {
    /// 单例
    static let share = FocusHelper()
    /// 当前需要聚焦的view
    var needFocusView : UIView?
    /// 强制聚焦的焦点数组
    var needFocusViewArr : [UIView]?
    
    /// 顶部控制器
    static var topVC : UIViewController? {
        /// keywindow
        var window : UIWindow?
        // 13.0以上
        if #available(iOS 13.0, tvOS 13, *) {
            window = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .map { $0 as? UIWindowScene }
                .compactMap { $0 }
                .first?.windows
                .filter { $0.isKeyWindow }.first
        } else {
            // 主控制器basecontroller刷新焦点
            window = UIApplication.shared.keyWindow
        }
        /// 头部控制器
        var topVC = window?.rootViewController ?? UIApplication.shared.delegate?.window??.rootViewController
        //
        while true {
            // 如果是原生
            if let presented = topVC?.presentedViewController {
                topVC = presented
                // 是导航栏 取当前控制器
            } else if let nav = topVC as? UINavigationController {
                topVC = nav.visibleViewController
            } else if let tab = topVC as? UITabBarController {
                // 是tabbar取选中控制器
                topVC = tab.selectedViewController
            } else {
                break
            }
        }
        return topVC
    }
    
    /// 强制聚焦到某个View
    static func focusToView(_ view : UIView?){
        // 记录该View
        FocusHelper.share.needFocusView = view
        
        // 如果是basecontroller类
        if let top = topVC as? BaseController {
            // 更新焦点
            top.setNeedsFocusUpdate()
            top.updateFocusIfNeeded()
        }
    }
    
    /// 强制聚焦到某些View
    static func focusToView(_ view : [UIView]?){
        // 记录该View
        FocusHelper.share.needFocusViewArr = view
        
        // 如果是basecontroller类
        if let top = topVC as? BaseController {
            // 更新焦点
            top.setNeedsFocusUpdate()
            top.updateFocusIfNeeded()
        }
    }
}


//MARK: - 焦点控制方式
/// 焦点控制方式
enum GuideControlType {
    /// 左右控制
    case leftAndRight
    /// 上下控制
    case upAndDown
}

//MARK: - 添加焦点
extension FocusHelper {
    /// 添加来回焦点(来与回)
    /// - Parameters:
    ///   - view: 添加到哪个view上
    ///   - toView: 去往哪个view
    ///   - backView: 回来是哪个view
    ///   - type: 通过什么按键控制
    /// - Returns: 返回写好的两个焦点对象
    @discardableResult static func setControlWith(view : UIView,
                                                  toView : UIView,
                                                  backView : UIView,
                                                  type : GuideControlType) -> (UIFocusGuide, UIFocusGuide) {
        let toGuide = UIFocusGuide()
        view.addLayoutGuide(toGuide)
        // 与需要聚焦的view宽高相等
        toGuide.widthAnchor.constraint(equalTo: toView.widthAnchor).isActive = true
        toGuide.heightAnchor.constraint(equalTo: toView.heightAnchor).isActive = true
        // 根据类型写方向
        if type == .leftAndRight {
            // 左右控制
            toGuide.centerXAnchor.constraint(equalTo: toView.centerXAnchor).isActive = true
            toGuide.centerYAnchor.constraint(equalTo: backView.centerYAnchor).isActive = true
        } else {
            // 上下控制
            toGuide.centerXAnchor.constraint(equalTo: backView.centerXAnchor).isActive = true
            toGuide.centerYAnchor.constraint(equalTo: toView.centerYAnchor).isActive = true
        }
        toGuide.preferredFocusedView = toView
        /// 返回焦点
        let backGuide = UIFocusGuide()
        view.addLayoutGuide(backGuide)
        backGuide.widthAnchor.constraint(equalTo: backView.widthAnchor).isActive = true
        backGuide.heightAnchor.constraint(equalTo: backView.heightAnchor).isActive = true
        // 根据类型写方向
        if type == .leftAndRight {
            // 左右控制
            backGuide.centerXAnchor.constraint(equalTo: backView.centerXAnchor).isActive = true
            backGuide.centerYAnchor.constraint(equalTo: toView.centerYAnchor).isActive = true
        } else {
            // 上下控制
            backGuide.centerXAnchor.constraint(equalTo: toView.centerXAnchor).isActive = true
            backGuide.centerYAnchor.constraint(equalTo: backView.centerYAnchor).isActive = true
        }
        // 返回焦点设置
        backGuide.preferredFocusedView = backView
        
        return (toGuide, backGuide)
    }
}
