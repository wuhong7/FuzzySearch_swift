//
//  SearchViewController.swift
//  FuzzySearch_swift
//
//  Created by 盖特 on 2017/5/19.
//  Copyright © 2017年 盖特. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setData()
        setupUI()
        
        self.view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: 属性
    ///排序前的整个数据源
    fileprivate var dataSource : [Any]!
    ///排序后的整个数据源
    fileprivate var allDataSource : [String : [Any]]!
    ///搜索结果数据源
    fileprivate var searchDataSource : [Any]!
    ///索引数据源
    fileprivate var indexDataSource : [String]!
    
    
    // MARK: 懒加载属性
    lazy var titleTableView : UITableView = {
        let titleTableView = UITableView(frame: CGRect.zero, style: .grouped)
        titleTableView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        titleTableView.delegate = self
        titleTableView.dataSource = self
        return titleTableView
    }()
    
    lazy var searchController : UISearchController = {
        
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "搜索"
        searchController.searchBar.sizeToFit()

        return searchController
    }()
    
    
    
}

// MARK: - UI
extension SearchViewController{
    
    func setupUI(){
        
        self.view.backgroundColor = UIColor.white
        view.addSubview(titleTableView)
        
        self.titleTableView.tableHeaderView = self.searchController.searchBar
    }
    
    
}

// MARK: - Data
extension SearchViewController{
    
    func setData(){
        
        /*
         _allDataSource = [HCSortString sortAndGroupForArray:_dataSource PropertyName:"name"];
         _indexDataSource = [HCSortString sortForStringAry:[_allDataSource allKeys]];
         */
        
        dataSource = ["九寨沟","鼓浪屿","香格里拉","千岛湖","西双版纳","+-*/","故宫","上海科技馆","东方明珠","外滩","CapeTown","The Grand Canyon","4567.com","长江","江长","长江1号","&*>?","弯弯月亮","that is it ?","山水之间","倩女幽魂","疆土无边","荡秋千"]
        searchDataSource = Array()
        allDataSource = WHSortString.sortAndGroupForArray(ary: dataSource, PropertyName: "name")
        indexDataSource = WHSortString.sortForStringAry(ary: Array(allDataSource.keys))

        self.titleTableView.reloadData()

        
    }
    
    
}



// MARK: - TableViewDelegate
extension SearchViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (!self.searchController.isActive) {
            return indexDataSource.count
        }else {
            return 1;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if (!self.searchController.isActive) {
            
            let value = allDataSource[indexDataSource[section]]
            return value!.count

        }else {
            return searchDataSource.count;
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell?.selectionStyle = .none
        }
        if (!self.searchController.isActive) {
            
            let value = allDataSource[indexDataSource[indexPath.section]] as! [String]
            cell?.textLabel?.text = value[indexPath.row]
        }else{
            cell?.textLabel?.text = searchDataSource[indexPath.row] as? String
        }
        return cell!
    }
    
    //头部索引标题
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (!self.searchController.isActive) {
            return indexDataSource[section]
        }else {
            return nil
        }
 
    }
    
    //右侧索引列表
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if (!self.searchController.isActive) {
            return indexDataSource
        }else {
            return nil;
        }
    }
    
    //索引点击事件
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        self.titleTableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: true)
        return index
        
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



extension SearchViewController : UISearchResultsUpdating{

    func updateSearchResults(for searchController: UISearchController) {
        
    }

    
    
}


// MARK: - 横竖屏适配
extension SearchViewController{
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        //titleTableView 布局
        titleTableView.frame = self.view.bounds
        
    }
  
    
}




