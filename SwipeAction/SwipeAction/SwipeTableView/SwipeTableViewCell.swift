//
//  SwipeTableViewCell.swift
//  SwipeAction
//
//  Created by lin on 2025/3/31.
//

import UIKit

/// 左滑事件cell
class SwipeTableViewCell : UITableViewCell {
    //MARK: - 属性相关
    
    //MARK: - 控件相关
    /// 左滑view
    private var swipeActionView : UIView?
    /// 设置左滑view约束/frame => 设置距离cell最右边即可
    private var updateActionViewFrame : (() -> Void)?
    /// 左滑阈值(是否完全展开)
    private var showAllWidth : CGFloat = 50
    /// 滑动手势识别器
    private var panGesture: UIPanGestureRecognizer?
    /// 标记是否已滑动出操作按钮
    private var isSwiped = false
    
    //MARK: - 属性相关
    /// 初始化
    /// - Parameters:
    ///   - style: 样式
    ///   - reuseIdentifier: 复用id
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 准备复用时调用
    override func prepareForReuse() {
        super.prepareForReuse()
        // 有手势的话移除
        if let panGesture {
            removeGestureRecognizer(panGesture)
        }
        // 复位滑动状态
        completionSwipe(animate: false)
    }
}

//MARK: - 左滑手势配置 => 公开方法
extension SwipeTableViewCell {
    /// 配置滑动操作
    /// - Parameter actionView: 左滑事件view
    /// - Parameter showAllWidth: 滑动距离超过多少的时候展示全部cell
    /// - Parameter updateFrame: 此时需要设置自定义view的布局或者宽度
    func configureSwipeActions(_ actionView : UIView?, showAllWidth : CGFloat = 50, updateFrame : (() -> Void)?) {
        // 存储自定义的view
        swipeActionView = actionView
        // 添加滑动手势识别器
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipePanAction))
        // 设置代理接收对象
        panGesture?.delegate = self
        // 存储滑动最小阈值
        self.showAllWidth = showAllWidth
        // 存储更新回调
        updateActionViewFrame = updateFrame
        // 取消可选值
        if let panGesture {
            // 添加手势
            addGestureRecognizer(panGesture)
        }
    }
    
    /// 完成操作
    func completionSwipe(animate : Bool = true){
        // 慢速左滑或右滑 - 收起操作视图
        resetSwipe(animated: true) { [weak self] in
            //
            if self?.swipeActionView?.superview == self?.contentView {
                self?.swipeActionView?.removeFromSuperview()
            }
        }
    }
}

//MARK: - 左滑手势配置 => 私有方法
extension SwipeTableViewCell {
    /// 处理滑动手势
    /// - Parameter gesture: 手势识别器
    @objc private func swipePanAction(_ gesture: UIPanGestureRecognizer) {
        // 确保滑动视图存在
        guard let swipeActionView = swipeActionView else { return }
        // 根据手势状态处理
        switch gesture.state {
        case .began: // 开始滑动
            // 判断是否有父类 有父类的话需要移除
            if let superCellView = swipeActionView.superview,
               superCellView != self.contentView {
                // 移除
                swipeActionView.removeFromSuperview()
                // 设置坐标
                swipeActionView.tag = (self.superview as? UITableView)?.indexPath(for: self)?.row ?? 0
                // 收起之前的view
                (superCellView.superview as? SwipeTableViewCell)?.completionSwipe(animate: true)
            }
            // 如果滑动视图尚未添加到视图层级，则添加它
            if swipeActionView.superview == nil {
                // 添加到contentView上防止阻拦点击事件
                contentView.addSubview(swipeActionView)
                // 设置为展示状态布局
                updateActionViewFrame?()
            }
        case .changed: // 改变时候
            /// 手势相对于初始坐标位移
            var moveX = gesture.translation(in: self).x
            // 如果已经展示
            if isSwiped {
                // 限制最小值 并且修改作用
                moveX = -swipeActionView.frame.width + moveX
            }
            // 防止超出左最大值
            moveX = max(-swipeActionView.frame.width, moveX)
            // 防止超出右最大值
            moveX = min(moveX, 0)
            // 滑动
            frame.origin.x = moveX
        case .ended, .cancelled:
            /// 手势速度
            let velocity = gesture.velocity(in: self)
            // 根据速度和位移决定是展开还是收起
            if velocity.x < -500 || -frame.origin.x > showAllWidth {
                // 快速左滑或滑动超过阈值 - 展开操作视图
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                    guard let self else {
                        return
                    }
                    self.layoutIfNeeded()
                    // 更新位置
                    self.frame.origin.x = -swipeActionView.frame.width
                })
                // 标记为已展示
                isSwiped = true
            } else {
                // 慢速左滑或右滑 - 收起操作视图
                completionSwipe()
            }
            
        default:
            break
        }
    }
    
    /// 复位滑动状态
    /// - Parameter animated: 是否使用动画
    func resetSwipe(animated: Bool, completion : (() -> Void)? = nil) {
        /// 复位动画
        let animations: () -> Void = { [weak self] in
            self?.frame.origin.x = 0
            self?.isSwiped = false
        }
        
        // 动画完成回调
        let animateCompletion: (Bool) -> Void = { _ in
            completion?()
        }
        
        // 根据参数决定是否使用动画
        if animated {
            UIView.animate(withDuration: 0.3, animations: animations, completion: animateCompletion)
        } else {
            // 直接修改
            animations()
            // 传出回调
            animateCompletion(true)
        }
    }
}

// MARK: - 手势识别器代理
extension SwipeTableViewCell {
    /// 决定手势是否应该开始
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 只处理滑动手势
        if gestureRecognizer == panGesture {
            let translation = panGesture?.translation(in: self) ?? .zero
            // 只响应水平滑动（x位移大于y位移）
            return abs(translation.x) > abs(translation.y)
        }
        return true
    }
    
    // 响应事件
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = super.hitTest(point, with: event)
        // 如果为空 那么判断
        if view == nil {
            /// 获取点击点位
            let point = self.convert(point, to: swipeActionView)
            // 如果在该坐标内
            if swipeActionView?.bounds.contains(point) == true {
                // 设置接收对象
                view = swipeActionView
            }
        }
        // 如果没有事件响应那么说明是滑动
        if view == nil && isSwiped {
            resetSwipe(animated: true)
        }
        return view
    }
}
