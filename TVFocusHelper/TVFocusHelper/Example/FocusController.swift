//
//  FocusController.swift
//  TVFocusHelper
//
//  Created by lin on 2025/2/14.
//

import UIKit
import SnapKit

/// 聚焦例子控制器
class BtnFocusController : BaseController {
    //MARK: - 属性相关
    
    //MARK: - 控件相关
    /// 按钮1
    lazy var oneBtn = getnormalBtn("one", tag: 1)
    /// 按钮2
    lazy var twoBtn = getnormalBtn("two", tag: 2)
    /// 按钮3
    lazy var threeBtn = getnormalBtn("three", tag: 3)
    /// 按钮4
    lazy var fourBtn = getnormalBtn("four", tag: 4)
    /// 按钮5
    lazy var fiveBtn = getnormalBtn("five", tag: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        // 添加控件
        view.addSubview(oneBtn)
        view.addSubview(twoBtn)
        view.addSubview(threeBtn)
        view.addSubview(fourBtn)
        view.addSubview(fiveBtn)
        // 添加约束
        oneBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(100)
        }
        twoBtn.snp.makeConstraints { make in
            make.top.equalTo(oneBtn.snp.bottom).offset(20)
            make.leading.equalTo(oneBtn.snp.trailing).offset(20)
            make.width.height.equalTo(oneBtn)
        }
        threeBtn.snp.makeConstraints { make in
            make.top.equalTo(twoBtn.snp.bottom).offset(20)
            make.leading.equalTo(twoBtn.snp.trailing).offset(20)
            make.width.height.equalTo(twoBtn)
        }
        fourBtn.snp.makeConstraints { make in
            make.top.equalTo(threeBtn.snp.bottom).offset(20)
            make.leading.equalTo(threeBtn.snp.trailing).offset(20)
            make.width.height.equalTo(threeBtn)
        }
        fiveBtn.snp.makeConstraints { make in
            make.top.equalTo(fourBtn.snp.bottom).offset(20)
            make.leading.equalTo(fourBtn.snp.trailing).offset(20)
            make.width.height.equalTo(fourBtn)
        }
        
        // 添加左右切换
        FocusHelper.setControlWith(view: view, toView: twoBtn, backView: oneBtn, type: .leftAndRight)
        FocusHelper.setControlWith(view: view, toView: threeBtn, backView: twoBtn, type: .leftAndRight)
        FocusHelper.setControlWith(view: view, toView: fourBtn, backView: threeBtn, type: .leftAndRight)
        FocusHelper.setControlWith(view: view, toView: fiveBtn, backView: fourBtn, type: .leftAndRight)
//        // 添加上下切换
//        FocusHelper.setControlWith(view: view, toView: twoBtn, backView: oneBtn, type: .upAndDown)
//        FocusHelper.setControlWith(view: view, toView: threeBtn, backView: twoBtn, type: .upAndDown)
//        FocusHelper.setControlWith(view: view, toView: fourBtn, backView: threeBtn, type: .upAndDown)
//        FocusHelper.setControlWith(view: view, toView: fiveBtn, backView: fourBtn, type: .upAndDown)
    }
    
    /// 获取默认样式按钮
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - tag: <#tag description#>
    /// - Returns: <#description#>
    func getnormalBtn(_ title : String, tag : Int) -> TestBtn {
        let btn = TestBtn()
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 32, weight: .medium)
        btn.tag = tag
        btn.addTarget(self, action: #selector(click), for: .primaryActionTriggered)
        btn.backgroundColor = .gray
        return btn
    }
    
    /// 按钮点击事件
    @objc func click(_ btn : UIButton){
        // 强行设置聚焦焦点
        switch btn.tag {
        // 聚焦到第二个按钮
        case 1 : FocusHelper.focusToView(twoBtn)
        // 聚焦到第三个按钮
        case 2 : FocusHelper.focusToView(threeBtn)
//        case 2 : FocusHelper.focusToView(fiveBtn)
        case 3 : FocusHelper.focusToView(fourBtn)
        case 4 : FocusHelper.focusToView(fiveBtn)
        case 5 : FocusHelper.focusToView(oneBtn)
        default : break
        }
    }
}

/// test
class TestBtn : UIButton {
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.isFocused {
            self.backgroundColor = .orange
        } else {
            self.backgroundColor = .gray
        }
    }
}
