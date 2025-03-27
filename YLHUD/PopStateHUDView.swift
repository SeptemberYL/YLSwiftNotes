//
//  PopStateView.swift
//  Demo
//
//  Created by lin on 2025/3/27.
//

import UIKit
import SnapKit

/// 弹窗状态
public enum PopState : Int {
    /// 加载状态
    case loading = 0
    /// 成功状态
    case success
    /// 失败状态
    case fail
    /// 仅展示文字
    case onlyTips
}

/// 状态弹窗
public class PopStateHUDView : UIView {
    //MARK: - 属性相关
    /// 配置
    var config : PopStateConfig
    /// 当前状态
    var state : PopState = .loading {
        didSet {
            stateUpdate()
        }
    }
    /// 是否正在旋转
    var isLooping : Bool = true
    /// 是否通过通知改变的隐藏状态
    private var isNotiUpdateHidden : Bool = false
    /// 关闭按钮回调
    var exitBlock : (() -> Void)?
    
    //MARK: - 控件相关
    /// 底板
    lazy var hudView : UIView = {
        let view = UIView()
        // hud底色
        view.backgroundColor = config.hudBackColor
        // hud圆角
        view.layer.cornerRadius = config.hudLayerRadius
        
        return view
    }()
    /// 状态图片窗口
    lazy var stateImageView : UIImageView = {
        let imv = UIImageView()
        // 默认使用加载图片
        imv.image = config.loadingImage
        
        return imv
    }()
    /// 提示语
    lazy var tipsLab : UILabel = {
        let lab = UILabel()
        // 设置字体
        lab.font = config.tipsFont
        // 设置颜色
        lab.textColor = config.tipsColor
        // 居中
        lab.textAlignment = .center
        
        return lab
    }()
    /// 关闭按钮
    lazy var exitBtn : UIButton = {
        let btn = UIButton()
        // 设置为关闭按钮
        btn.setImage(config.exitImage, for: .normal)
        // 添加点击事件
        btn.addTarget(self, action: #selector(exitBtnClick), for: .touchUpInside)
        // 是否隐藏
        btn.isHidden = !config.isShowExit || state == .onlyTips
        
        return btn
    }()
    
    //MARK: - 初始化
    /// 通过配置初始化
    /// - Parameter config: <#config description#>
    init(config: PopStateConfig) {
        self.config = config
        super.init(frame: .zero)
        
        makeUI()
        makeConstraints()
        // 旋转
        loopRotate()
        // 如果不是loading的话 在初始化之后就等待消失
        if state != .loading {
            showAndHide(false)
        }
        // 添加进入app通知
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { [weak self] noti in
            // 通过通知改变的隐藏状态
            if self?.isNotiUpdateHidden == true && self?.isHidden == true {
                self?.isHidden = false
            }
        }
        // 添加退出app通知
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { [weak self] noti in
            // 通过通知改变的隐藏状态
            if self?.isHidden == false {
                self?.isNotiUpdateHidden = true
                self?.isHidden = true
            }
        }
    }
    // 销毁
    deinit {
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
public extension PopStateHUDView {
    /// 添加控件
    private func makeUI(){
        backgroundColor = config.backColor
        
        addSubview(hudView)
        hudView.addSubview(stateImageView)
        hudView.addSubview(tipsLab)
        hudView.addSubview(exitBtn)
    }
    /// 添加约束
    private func makeConstraints(){
        // 弹窗
        hudView.snp.makeConstraints { make in
            setHUDViewSNP(make)
        }
        
        // 状态icon
        stateImageView.snp.makeConstraints { make in
            setStateImageSNP(make)
        }
        // 提示语
        tipsLab.snp.makeConstraints { make in
            make.top.equalTo(stateImageView.snp.bottom).offset(config.tipsEdgs.top)
            make.leading.equalToSuperview().offset(config.tipsEdgs.left)
            make.trailing.equalToSuperview().offset(-config.tipsEdgs.right)
            make.bottom.greaterThanOrEqualToSuperview().offset(-config.tipsEdgs.bottom)
        }
        // 关闭按钮
        exitBtn.snp.makeConstraints { make in
            // 如果有设置任意间距 那么就使用
            if config.exitEdgs.top != 0 {
                make.top.equalToSuperview().offset(config.exitEdgs.top)
            }
            if config.exitEdgs.right != 0 {
                make.trailing.equalToSuperview().offset(-config.exitEdgs.right)
            }
            if config.exitEdgs.bottom != 0 {
                make.bottom.equalToSuperview().offset(-config.exitEdgs.bottom)
            }
            if config.exitEdgs.left != 0 {
                make.trailing.equalToSuperview().offset(config.exitEdgs.left)
            }
            make.width.equalTo(config.exitImageSize.width)
            make.height.equalTo(config.exitImageSize.height)
        }
    }
    
    /// 设置底板约束
    private func setHUDViewSNP(_ make : ConstraintMaker){
        make.center.equalToSuperview()
        // 不是提示语的话正常使用
        if state != .onlyTips {
            // 设置最小尺寸
            make.width.greaterThanOrEqualTo(config.hudMinSize.width)
            make.height.greaterThanOrEqualTo(config.hudMinSize.height)
            // 设置最大尺寸
            make.width.lessThanOrEqualTo(config.hudMaxSize.width)
            make.height.lessThanOrEqualTo(config.hudMaxSize.height)
        } else {
            // 提示语
            if let minSize = config.onlyTipsHudMinxSize {
                // 提示语需要判断最小最大
                make.width.greaterThanOrEqualTo(minSize.width)
                make.height.greaterThanOrEqualTo(minSize.height)
            }
            if let maxSize = config.onlyTipsHudMaxSize {
                // 提示语需要判断最小最大
                make.width.greaterThanOrEqualTo(maxSize.width)
                make.height.greaterThanOrEqualTo(maxSize.height)
            }
        }
    }
    
    /// 设置状态icon约束
    private func setStateImageSNP(_ make : ConstraintMaker){
        // 距上
        make.top.equalToSuperview().offset(config.imageEdgs.top)
        // 如果左右为0就是居中
        if config.imageEdgs.left == 0 && config.imageEdgs.right == 0 {
            make.centerX.equalToSuperview()
        } else {
            // 距左
            if config.imageEdgs.left != 0 {
                make.leading.equalToSuperview().offset(config.imageEdgs.left)
            }
            // 距右
            if config.imageEdgs.right != 0 {
                make.trailing.equalToSuperview().offset(-config.imageEdgs.right)
            }
        }
        // 设置图片尺寸
        if state == .loading {
            // 如果正在加载中
            make.width.equalTo(config.loadingSize.width)
            make.height.equalTo(config.loadingSize.height)
        } else if state == .success {
            // 成功
            make.width.equalTo(config.successSize?.width ?? config.loadingSize.width)
            make.height.equalTo(config.successSize?.height ?? config.loadingSize.height)
        } else if state == .fail {
            // 失败
            make.width.equalTo(config.failSize?.width ?? config.loadingSize.width)
            make.height.equalTo(config.failSize?.height ?? config.loadingSize.height)
        }
    }
    
    /// 关闭按钮点击事件
    @objc func exitBtnClick(_ btn : UIButton){
        exitBlock?()
    }
}

//MARK: - 状态改变/动画
public extension PopStateHUDView {
    /// 状态改变
    func stateUpdate(){
        switch state {
        case .loading : // 加载
            stateImageView.image = config.loadingImage
        case .success : // 成功
            stateImageView.image = config.successImage
            exitBtn.isHidden = true // 隐藏关闭按钮
            showAndHide(false) // 隐藏
        case .fail : // 失败
            stateImageView.image = config.failImage
            exitBtn.isHidden = true // 隐藏关闭按钮
            showAndHide(false) // 隐藏
        case .onlyTips : // 仅展示文本
            // 提示状态不展示加载图片
            stateImageView.isHidden = true
            exitBtn.isHidden = true
            // 提示语
            tipsLab.snp.remakeConstraints { make in
                /// 间距
                let edgs = config.onlyTipsEdgs ?? config.tipsEdgs
                make.top.equalToSuperview().offset(edgs.top)
                make.leading.equalToSuperview().offset(edgs.left)
                make.trailing.equalToSuperview().offset(-edgs.right)
                make.bottom.equalToSuperview().offset(-edgs.bottom)
            }
            // 修改约束
            hudView.snp.remakeConstraints { make in
                setHUDViewSNP(make)
            }
            showAndHide(false) // 隐藏
        }
        // 未在旋转开启旋转 旋转中关闭旋转 // 做一层判断防止重复执行loading
        if (!isLooping && state == .loading) || (isLooping && state != .loading) {
            // 旋转 | 停止旋转
            loopRotate()
        }
        // 状态icon修改
        stateImageView.snp.remakeConstraints { make in
            setStateImageSNP(make)
        }
    }
    
    /// 无限旋转
    func loopRotate(){
        // 被除数不可为空
        if config.loadingRotateDuration == 0 {
            // 标记为未旋转
            isLooping = false
            return
        }
        // 如果不是加载 那么就回到原位置
        if state != .loading {
            stateImageView.transform = .init(scaleX: 1, y: 1)
            // 标记为未旋转
            isLooping = false
            return
        }
        // 标记为旋转中
        isLooping = true
        /// 四分之一圈时长
        let duration = config.loadingRotateDuration / 4
        UIView.animate(withDuration: duration, delay: 0, options: .beginFromCurrentState) { [weak self] in
            self?.stateImageView.transform = self?.stateImageView.transform.rotated(by: .pi / 2.0) ?? .init(scaleX: 1, y: 1)
        } completion: { [weak self] _ in
            self?.loopRotate()
        }
    }
    
    /// 展示与隐藏
    func showAndHide(_ show : Bool){
        // 透明度
        hudView.alpha = show ? 0 : 1
        // 淡入 淡出
        UIView.animate(withDuration: config.hudDissmissAnimateDuration,
                       delay: show ? 0 : config.hudDismissDelay) { [weak self] in
            // 展示
            self?.hudView.alpha = show ? 1 : 0
        } completion: { [weak self] _ in
            if !show && self?.superview != nil {
                self?.removeFromSuperview()
            }
        }
        // 隐藏的话移除存储
        YLHUD.popHudView = nil
    }
}

public extension PopStateHUDView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 1. 判断自己能否接收事件
        guard self.isUserInteractionEnabled, !self.isHidden, self.alpha > 0.01 else {
            return nil
        }
        
        // 2. 判断点是否在当前控件上
        guard self.point(inside: point, with: event) else {
            return nil
        }
        
        // 3. 检查是否是点击了 hudView
        let hudPoint = self.convert(point, to: hudView)
        if hudView.point(inside: hudPoint, with: event) {
            // 点击了 hudView，直接返回 hudView 拦截事件
            return hudView
        }
        // 如果拦截点击事件
        if config.isUnableClick {
            // 拦截
            return self
        } else {
            // 不拦截
            return nil
        }
    }
}
