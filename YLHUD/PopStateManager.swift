//
//  PopStateManager.swift
//  Demo
//
//  Created by lin on 2025/3/27.
//

import Foundation
import UIKit

/// 弹窗工具类
public class PopStateManager : NSObject {
    /// 单例
    static let share = PopStateManager()
    /// 存储的配置
    var config : PopStateConfig = PopStateConfig()
    /// 当前展示的弹窗
    var popHudView : PopStateHUDView?
}
/// 快捷访问
public let YLHUD = PopStateManager.share

//MARK: - 寻找keywindow
public extension PopStateManager {
    /// 返回keywindow
    static var keyWindow : UIWindow? {
        /// 主控
        var window : UIWindow?
        // 13以上
        if #available(tvOS 13.0, *) {
            window = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .map { $0 as? UIWindowScene }
                .compactMap { $0 }
                .first?.windows
                .filter { $0.isKeyWindow }.first
        } else {
            // 13以下
            window = UIApplication.shared.keyWindow ?? UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        }
        return window
    }
}

//MARK: - 配置相关
public extension PopStateManager {
    /// 设置配置
    func setConfig(block : ((inout PopStateConfig) -> Void)?){
        block?(&config)
    }
}

//MARK: - 弹窗方法
public extension PopStateManager {
    /// 弹出加载弹窗
    /// - Parameters:
    ///   - state: 弹窗状态
    ///   - tips: 提示语
    ///   - onceConfig: 单次配置,不影响全局
    ///   - exitBlock: 关闭按钮点击回调
    func showPopWith(_ state : PopState,
                     tips : String,
                     onceConfig : ((inout PopStateConfig) -> Void)? = nil,
                     exitBlock : (() -> Void)? = nil){
        /// 本次使用的配置
        var config = config
        // 获取回调
        if let onceConfig {
            // 传入修改
            onceConfig(&config)
        }
        // 仅提示的话需要额外修改
        if state == .onlyTips {
            /// 生成仅使用一次的弹窗
            let hudView = PopStateHUDView(config: config)
            // 更新状态
            hudView.state = state
            hudView.tipsLab.text = tips
            // 添加到keywindow上
            PopStateManager.keyWindow?.addSubview(hudView)
            // 设置约束
            hudView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            return
        }
        /// 初始化弹窗
        let hudView = popHudView ?? PopStateHUDView(config: config)
        // 提示语
        hudView.tipsLab.text = tips
        // 存储
        popHudView = hudView
        // 如果没有父类那么就添加
        if hudView.superview == nil {
            // 添加到keywindow上
            PopStateManager.keyWindow?.addSubview(hudView)
            // 设置约束
            hudView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        // 更新状态
        hudView.state = state
        // 如果有设置关闭回调
        hudView.exitBlock = exitBlock
    }
}

//MARK: - 展示banner
extension PopStateManager {
    /// 展示banner
    func showBanner(tips : String,
                    onceConfig : ((inout PopStateConfig) -> Void)? = nil){
        /// 本次使用的配置
        var config = config
        // 获取回调
        if let onceConfig {
            // 传入修改
            onceConfig(&config)
        }
        /// 初始化的bannerView
        let view = PopStateBannerView(config: config)
        // 设置文本提示
        view.tipsLab.text = tips
        // 添加到keywindow
        PopStateManager.keyWindow?.addSubview(view)
        // 展示
        view.snp.makeConstraints { make in
            view.setSNP(show: false, make: make)
        }
        view.superview?.layoutIfNeeded()
        // 展示完成后紧接着准备移除
        view.showOrHide(true) {
            view.showOrHide(false)
        }
    }
}
