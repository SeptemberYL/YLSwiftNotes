# YLSwiftNotes
用于存储代码量少的小工具

## 文件目录与简介 === 按照写这段代码的时间排序
- TVFocusHelper 用于tvos焦点切换与强制聚焦
```
每个项目运行前pod install一下就可以运行了
```

### TVFocusHelper tvos焦点切换
```
// example文件夹中有具体示例
用于tvos中 焦点切换
1.强制将当前控制器的焦点切换到什么view上
2.设置焦点可以通过按键左右/上下 来回切换

// 父类控制器中复写以下方法
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
    
// 添加左右切换焦点
FocusHelper.setControlWith(view: view, toView: twoBtn, backView: oneBtn, type: .leftAndRight)

// 添加上下切换
FocusHelper.setControlWith(view: view, toView: twoBtn, backView: oneBtn, type: .upAndDown)

/// 按钮点击事件
@objc func click(_ btn : UIButton){
    // 强行设置聚焦焦点
    switch btn.tag {
    // 聚焦到第二个按钮
    case 1 : FocusHelper.focusToView(twoBtn)
    // 聚焦到第三个按钮
    case 2 : FocusHelper.focusToView(threeBtn)
//  case 2 : FocusHelper.focusToView(fiveBtn)
    case 3 : FocusHelper.focusToView(fourBtn)
    case 4 : FocusHelper.focusToView(fiveBtn)
    case 5 : FocusHelper.focusToView(oneBtn)
    default : break
    }
}
```

### YLHUD 弹窗 loading success fail 三种状态 也可以仅文字提示 banner提示
加载弹窗,下载YLHUD文件夹下全部文件 并且在podfile文件中
pod 'SnapKit' # 约束第三方库
在终端pod install 一下

### SwipeTableViewCell 左滑功能列表
下载SwipeTableViewCell.swift文件 拉进项目内可以直接使用
可以继承自定义ui
```
    /// 测试按钮
    lazy var testBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black.withAlphaComponent(0.8)
        btn.setTitle("test", for: .normal)
        btn.addTarget(self, action: #selector(testClick), for: .touchUpInside)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    // 注册单元格
    tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "SwipeableCell")
    
    // 获取复用单元格
    let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeableCell", for: indexPath) as! SwipeTableViewCell
    
    // 配置单元格滑动操作
    cell.configureSwipeActions(testBtn) {
        // 设置约束/直接设置frame都可以
        self.testBtn.frame = CGRect(x: cell.bounds.width, y: 0, width: cell.bounds.height, height: cell.bounds.height)
    }
```
