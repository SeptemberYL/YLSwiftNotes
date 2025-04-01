//
//  ViewController.swift
//  SwipeAction
//
//  Created by lin on 2025/3/31.
//

import UIKit

//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//
//
//}

/// 示例视图控制器
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - 属性
    
    /// 表格视图
    lazy var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    /// 测试按钮
    lazy var testBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black.withAlphaComponent(0.8)
        btn.setTitle("test", for: .normal)
        btn.addTarget(self, action: #selector(testClick), for: .touchUpInside)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    @objc func testClick(_ btn : UIButton){
        print("test点击row为 => \(btn.tag)的cell")
    }
    // MARK: - 生命周期方法
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
        // 注册单元格
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "SwipeableCell")
        // 设置行高
        tableView.rowHeight = 60
    }
    
    // MARK: - 表格视图数据源
    
    /// 返回表格行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    /// 配置表格单元格
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 获取复用单元格
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeableCell", for: indexPath) as! SwipeTableViewCell
        
        // 配置单元格内容
        cell.textLabel?.text = "Item \(indexPath.row + 1)"
        
        // 配置单元格滑动操作
        cell.configureSwipeActions(testBtn) {
            // 设置约束/直接设置frame都可以
            self.testBtn.frame = CGRect(x: cell.bounds.width, y: 0, width: cell.bounds.height, height: cell.bounds.height)
        }
        
        return cell
    }
    
    // MARK: - 表格视图代理
    
    /// 处理行选择事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消选中状态
        tableView.deselectRow(at: indexPath, animated: true)
        // 打印选中行
        print("Selected row \(indexPath.row)")
    }
}
