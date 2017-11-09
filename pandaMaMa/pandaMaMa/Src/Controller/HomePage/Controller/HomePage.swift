//
//  HomePage.swift
//  pandaMaMa
//
//  Created by tree on 2017/7/5.
//  Copyright © tree. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HomePage: CommonViewController,UITableViewDelegate, UITableViewDataSource,  HomeServiceDelegate {
    //MARK:property
    var moduleArray: [[String: AnyObject]] = []
    var bannerArray: [[String: AnyObject]] = [
        ["pic":"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505972754561&di=569f6163fc6f6d0121e9d3d8229c2946&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2F6d81800a19d8bc3e3bad2adf888ba61ea8d34579.jpg" as AnyObject],
        ["pic":"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505973029865&di=ffdfe764719be6449619380b25db2d04&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D2603370572%2C337907411%26fm%3D214%26gp%3D0.jpg" as AnyObject],
         ["pic":"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505973168071&di=7f0ef7c0908f6b9fe4f3c556d1d185b8&imgtype=0&src=http%3A%2F%2Fwww.pp3.cn%2Fuploads%2Fallimg%2F111120%2F1003433962-9.jpg" as AnyObject]]
    
    var crossArray: [[String: AnyObject]] = []
    var cheeperArray: [[String: AnyObject]] = []
    var hotArray: [[String: AnyObject]] = []
    var newArray: [[String: AnyObject]] = []
    var recommandArray: [[String: AnyObject]] = []
    
    let service: HomeService = {
        return HomeService.init()
    }()
    
    var tableData: [[String: Any]] = []
    //MARK:systemCycle
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        super.viewDidLoad()
        self.service.delegate = self
        self.title = "首页"
        self.tableData = prepareTableSource()
        self.createUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.showDefaultHub(self.view, message: kHttp_Notice_LoadingText)
        self.service.getBannerInfo()
    }
    //MARK:HTTP
    /// 获得首页轮播图信息
    func didGetBannerInfo(dictionary: AnyObject?, isSuccess: Bool, responseObject: [String : Any]?) {
        self.hidHub()
        if isSuccess == false {
            handleResponse(response: responseObject)
            return
        }
        if let banner: [AnyObject] = dictionary?["banner"] as? [AnyObject] {
            if let o = banner as? [[String : AnyObject]] {
                self.bannerArray = o
            }
        }
        if let cate: [AnyObject] = dictionary?["cate"] as? [AnyObject] {
            if let o = cate as? [[String : AnyObject]] {
                self.moduleArray = o
            }
        }
        self.tableData = prepareTableSource()
        self.tableView.reloadData()
    }
    
    
    func didGetGoodBannerInfo(dictionary: AnyObject?, isSuccess: Bool, responseObject: [String : Any]?) {
        self.hidHub()
        if isSuccess == false {
            handleResponse(response: responseObject)
            return
        }
        if let hot: [AnyObject] = dictionary?["hot"] as? [AnyObject] {
            if let o = hot as? [[String: AnyObject]] {
                self.hotArray = o
            }
        }
        if let new: [AnyObject] = dictionary?["new"] as? [AnyObject] {
            if let o = new as? [[String: AnyObject]] {
                self.newArray = o
            }
        }
        if let overSea: [AnyObject] = dictionary?["overSea"] as? [AnyObject] {
            if let o = overSea as? [[String: AnyObject]] {
                self.crossArray = o
            }
        }
        self.tableData = prepareTableSource()
        self.tableView.reloadData()
    }
    //MARK:delegate&dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionDict = self.tableData[section]
        if let num: Int = sectionDict[kTableVIewNumberOfRowsKey] as? Int { return num } else { return 0 }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionDict = self.tableData[indexPath.section]
        if let cellList: [[String: Any]] = sectionDict[kTableViewCellListKey] as? [[String : Any]] {
            let cellDict = cellList[indexPath.row]
            if let cellHeight: CGFloat = cellDict[kTableViewCellHeightKey] as? CGFloat {
                return cellHeight
            }
        }
        return 0.01
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionDict = self.tableData[indexPath.section]
        guard let cellList: [[String: Any]] = sectionDict[kTableViewCellListKey] as? [[String : Any]] else { return UITableViewCell.init() }
        let cellDict = cellList[indexPath.row]
        guard let type: String = cellDict[kTableViewCellTypeKey] as? String else { return UITableViewCell.init() }
        switch type {
        case "HomeBanner_Cell":
            let cell: HomeBannerCell = tableView.dequeueReusableCell(withIdentifier: "HomeBanner_Cell") as! HomeBannerCell
            if self.bannerArray.count > 0 {
                cell.bannerArray = self.bannerArray
            }
            return cell
        case "HomeModule_Cell":
            let cell: HomeModuleCell = tableView.dequeueReusableCell(withIdentifier: "HomeModule_Cell") as! HomeModuleCell
            cell.cellButtons(buttonInfo: self.moduleArray)
            return cell
        case "HomeCenterTitle_Cell":
            let cell: HomeCenterTitleCell = tableView.dequeueReusableCell(withIdentifier: "HomeCenterTitle_Cell") as! HomeCenterTitleCell
            if let cellData: [String: String] = cellDict[kTableViewCellDataKey] as? [String : String]  {
                cell.title = cellData["title"]
                cell.titleImage = UIImage(named: cellData["img"] ?? "")
                cell.titleColor = UIColor.color(cellData["titleColor"] ?? "")
            }
            return cell
        default:
            return UITableViewCell.init()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let commonPage: CommonViewController = CommonViewController()
        navigationController?.pushViewController(commonPage, animated: true)
    }
    //MARK:customMethod
    private func createUI() {
        self.view.addSubview(self.tableView)
        self.tableView.register(HomeBannerCell.self, forCellReuseIdentifier: "HomeBanner_Cell")
        self.tableView.register(HomeModuleCell.self, forCellReuseIdentifier: "HomeModule_Cell")
        self.tableView.register(HomeCenterTitleCell.self, forCellReuseIdentifier: "HomeCenterTitle_Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(64.0)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom).offset(-44.0)
        }
    }
    private func prepareTableSource() -> [[String: Any]] {
        var array: [Dictionary<String, Any>] = []
        array.append({//轮播图
            var sectionDict: [String: Any] = [:]
            var cellList:[Dictionary<String, Any>] = []
            cellList.append({
                let cellDict: [String: Any] = [kTableViewCellTypeKey:"HomeBanner_Cell", kTableViewCellHeightKey: HomeBannerCell.cellHeight()]
                return cellDict
                }())
            sectionDict[kTableVIewNumberOfRowsKey] = cellList.count
            sectionDict[kTableViewCellListKey] = cellList
            return sectionDict
            }())
        
        
        array.append({//按钮模块
            var sectionDict: [String: Any] = [:]
            var cellList:[Dictionary<String, Any>] = []
            cellList.append({
                let cellDict: [String: Any] = [kTableViewCellTypeKey:"HomeModule_Cell", kTableViewCellHeightKey: HomeModuleCell.cellHeight(modules: self.moduleArray)]
                return cellDict
                }())
            sectionDict[kTableVIewNumberOfRowsKey] = cellList.count
            sectionDict[kTableViewCellListKey] = cellList
            return sectionDict
            }())
        
        array.append({//优惠多多标题
            var sectionDict: [String: Any] = [:]
            var cellList:[Dictionary<String, Any>] = []
            cellList.append({
                let cellDict: [String: Any] = [kTableViewCellTypeKey:"HomeCenterTitle_Cell", kTableViewCellHeightKey: HomeCenterTitleCell.cellHeight(), kTableViewCellDataKey: ["img": "HomeModuleLogo.bundle/logo_cheeper", "title": "优惠多多", "titleColor": "#23ead3"]]
                return cellDict
                }())
            sectionDict[kTableVIewNumberOfRowsKey] = cellList.count
            sectionDict[kTableViewCellListKey] = cellList
            return sectionDict
            }())
        
        if self.crossArray.count > 0 {
            array.append({//跨境专区
                var sectionDict: [String: Any] = [:]
                var cellList:[Dictionary<String, Any>] = []
                cellList.append({
                    let cellDict: [String: Any] = [kTableViewCellTypeKey:"HomeCenterTitle_Cell", kTableViewCellHeightKey: HomeCenterTitleCell.cellHeight(), kTableViewCellDataKey: ["img": "HomeModuleLogo.bundle/logo_crossborder", "title": "跨境专区", "titleColor": "#0fa9c0"]]
                    return cellDict
                    }())
                
                sectionDict[kTableVIewNumberOfRowsKey] = cellList.count
                sectionDict[kTableViewCellListKey] = cellList
                return sectionDict
                }())
        }
        
        if self.hotArray.count > 0 {
            array.append({//爆款专区
                var sectionDict: [String: Any] = [:]
                var cellList:[Dictionary<String, Any>] = []
                cellList.append({
                    let cellDict: [String: Any] = [kTableViewCellTypeKey:"HomeCenterTitle_Cell", kTableViewCellHeightKey: HomeCenterTitleCell.cellHeight(), kTableViewCellDataKey: ["img": "HomeModuleLogo.bundle/logo_hotsail", "title": "爆款热卖", "titleColor":"#e93421"]]
                    return cellDict
                    }())
                sectionDict[kTableVIewNumberOfRowsKey] = cellList.count
                sectionDict[kTableViewCellListKey] = cellList
                return sectionDict
                }())
        }
        
        if self.newArray.count > 0 {
            array.append({//新品发布
                var sectionDict: [String: Any] = [:]
                var cellList:[Dictionary<String, Any>] = []
                cellList.append({
                    let cellDict: [String: Any] = [kTableViewCellTypeKey:"HomeCenterTitle_Cell", kTableViewCellHeightKey: HomeCenterTitleCell.cellHeight(), kTableViewCellDataKey: ["img": "HomeModuleLogo.bundle/logo_newgoods", "title": "新品发布", "titleColor": "#990a89"]]
                    return cellDict
                    }())
                sectionDict[kTableVIewNumberOfRowsKey] = cellList.count
                sectionDict[kTableViewCellListKey] = cellList
                return sectionDict
                }())
        }
        
        if self.recommandArray.count > 0 {
            array.append({//为您推荐
                var sectionDict: [String: Any] = [:]
                var cellList:[Dictionary<String, Any>] = []
                cellList.append({
                    let cellDict: [String: Any] = [kTableViewCellTypeKey:"HomeCenterTitle_Cell", kTableViewCellHeightKey: HomeCenterTitleCell.cellHeight(), kTableViewCellDataKey: ["img": "HomeModuleLogo.bundle/logo_recommend", "title": "为您推荐", "titleColor": "#e93421"]]
                    return cellDict
                    }())
                sectionDict[kTableVIewNumberOfRowsKey] = cellList.count
                sectionDict[kTableViewCellListKey] = cellList
                return sectionDict
                }())
        }
        
        return array
    }
}

