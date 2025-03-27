//
//  PopStateBannerView.swift
//  Demo
//
//  Created by lin on 2025/3/27.
//

import UIKit
import SnapKit

/// 顶部弹窗BannerView
class PopStateBannerView : UIView {
    //MARK: - 属性相关
    /// 配置
    var config : PopStateConfig
    
    //MARK: - 控件相关
    /// 提示语
    lazy var tipsLab : UILabel = {
        let lab = UILabel()
        lab.font = config.bannerTipsFont
        lab.textColor = config.bannerTipsColor
        lab.numberOfLines = 0
        
        return lab
    }()
    
    init(config: PopStateConfig) {
        self.config = config
        super.init(frame: .zero)
        
        makeUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
extension PopStateBannerView {
    /// 添加控件
    private func makeUI(){
        // 设置底板
        backgroundColor = config.bannerBackColor
        layer.cornerRadius = config.bannerLayerRadius
        
        addSubview(tipsLab)
    }
    /// 添加约束
    private func makeConstraints(){
        // 提示语
        tipsLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            // 最大尺寸
            make.height.lessThanOrEqualToSuperview().offset(config.bannerTipsEdgs.top + config.bannerTipsEdgs.bottom)
            make.leading.equalToSuperview().offset(config.bannerTipsEdgs.left)
            make.trailing.equalToSuperview().offset(-config.bannerTipsEdgs.right)
        }
    }
    /// 设置snp
    func setSNP(show : Bool, make : ConstraintMaker){
        // 设置间距
        if config.bannerEdgs.top != 0 {
            make.top.equalToSuperview().offset(show ? config.bannerEdgs.top : -config.bannerHeight)
        } else if config.bannerEdgs.bottom != 0 {
            make.bottom.equalToSuperview().offset(show ? -config.bannerEdgs.bottom : config.bannerHeight)
        }
        // 挤压出来宽
        make.leading.equalToSuperview().offset(config.bannerEdgs.left)
        make.trailing.equalToSuperview().offset(-config.bannerEdgs.right)
        // 写死高度
        make.height.equalTo(config.bannerHeight)
    }
}

//MARK: - 动画
extension PopStateBannerView {
    /// 展示与收起
    /// - Parameters:
    ///   - show: 展示?隐藏
    ///   - completion: 完成回调
    func showOrHide(_ show : Bool, _ completion : (() -> Void)? = nil){
        snp.remakeConstraints { make in
            // 更新snp
            setSNP(show: show, make: make)
        }
        // 动画时长 延迟
        UIView.animate(withDuration: config.bannerAnimateDuration, delay: show ? 0 : config.bannerAnimateDelay) { [weak self] in
            self?.superview?.layoutIfNeeded()
        } completion: { [weak self] _ in
            // 如果隐藏的话需要移除
            if self?.superview != nil && !show {
                self?.removeFromSuperview()
            }
            completion?()
        }
    }
}
