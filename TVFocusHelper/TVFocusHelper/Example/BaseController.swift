//
//  BaseController.swift
//  TVFocusHelper
//
//  Created by lin on 2025/2/14.
//

import UIKit

/// 基础控制器 (用于设置preferredFocusEnvironments 聚焦)
class BaseController : UIViewController {
    /// 可聚焦view
    override var preferredFocusEnvironments: [any UIFocusEnvironment] {
        get {
            // 可聚焦数组
            if let arr = FocusHelper.share.needFocusViewArr {
                // 移除本次记录
                FocusHelper.share.needFocusViewArr = nil
                return arr
            }
            // 如果有这些焦点
            if let view = FocusHelper.share.needFocusView {
                // 移除本次记录
                FocusHelper.share.needFocusView = nil
                return [view]
            }
            // 如果没有就正常执行聚焦
            return super.preferredFocusEnvironments
        }
    }
}
