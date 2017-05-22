//
//  ViewController.swift
//  FuzzySearch_swift
//
//  Created by 盖特 on 2017/5/19.
//  Copyright © 2017年 盖特. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: 属性
    var dataSource : Array<Any>!
    
    // MARK: 懒加载属性
    lazy var titleTableView : UITableView = {
        let titleTableView = UITableView(frame: CGRect.zero, style: .grouped)
        titleTableView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        titleTableView.delegate = self
        titleTableView.dataSource = self
        return titleTableView
    }()
    
}


// MARK: - UI
extension ViewController{
    
    fileprivate func setupUI(){
        
        self.navigationItem.title = "搜索类型"
        self.view.backgroundColor = UIColor.white
        let back = UIBarButtonItem()
        back.title = ""
        self.navigationItem.backBarButtonItem = back
        dataSource = ["搜索栏滚动式通讯录","搜索栏固定式通讯录","单独调用搜索功能","传入Model排序搜索"]
        view.addSubview(titleTableView)

    }
  
}

// MARK: - delegate
extension ViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell?.selectionStyle = .none
        }
        cell?.textLabel?.text = dataSource[indexPath.row] as? String
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell?.detailTextLabel?.minimumScaleFactor = 0.5
        
        switch indexPath.row {
        case 0:
            
            let searchVC = SearchViewController()
            searchVC.title = dataSource[indexPath.row] as? String
            self.navigationController?.pushViewController(searchVC, animated: true)
            
            
        default:
            break
        }
        
        
        
        
        
        
        
        
    }
    
    
    
}


// MARK: - 横竖屏适配
extension ViewController{
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        //titleTableView 布局
        titleTableView.frame = self.view.bounds
        
        
    }
    
    
    
    
}



