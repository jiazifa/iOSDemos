//
//  CommonViewController.swift
//  AnAnOrderCarDriver
//
//  Created by Mac on 17/3/24.
//  Copyright © 2017年 treee. All rights reserved.
//

import Foundation
import UIKit
import SSKitSwift
import SSFormSwift

class CommonViewController: UIViewController {
    //MARK:-
    //MARK:properties
    
    var tableView:UITableView = {
        return UITableView.tableView()
    }()
    
    var formTable:UITableView = {
        let _tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        _tableView.indicatorStyle = .white
        _tableView.isScrollEnabled = true
        _tableView.isUserInteractionEnabled = true
        _tableView.backgroundColor = UIColor.clear
        _tableView.backgroundView = nil
        _tableView.tableFooterView = UIView.init()
        
        _tableView.sectionHeaderHeight = 0.0
        _tableView.sectionFooterHeight = 0.0
        
        _tableView.separatorStyle = .singleLine
        return _tableView
    }()
    /// 设置页面的标题
    override var title: String? {
        didSet{
            let _titleView:UILabel = UILabel.init()
            _titleView.textColor = UIColor.white
            _titleView.backgroundColor = UIColor.clear
            _titleView.font = UIFont.systemFont(ofSize: 19.0)
            _titleView.textAlignment = .center
            let frame:CGRect = _titleView.frame
            _titleView.frame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 34.0)
            self.navigationItem.titleView = _titleView
            _titleView.text = title
        }
    }
    
    //MARK:-
    //MARK:lifeCycle
    
    override func loadView() {
        super.loadView()
        self.view.isExclusiveTouch = true//设置界面的排他性，避免多个控件同时接受点击事件
        self.view.backgroundColor = UIColor.white
        self.commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let value:NSNumber = NSNumber.init(value: UIInterfaceOrientation.portrait.rawValue)
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    //MARK:-
    //MARK:delegate&dataSource
    
    
    //MARK:-
    //MARK:publicMethod
    public func controller() -> CommonViewController {
        return self
    }
    //MARK:-
    //MARK:helper
    
    func commonInit() -> Void {
        self.navigationController?.navigationBar.shadowImage = UIImage.init()
        self.navigationController?.navigationBar.backgroundColor = UIColor.color(kColor_Blue)
        self.navigationController?.navigationBar.barTintColor = UIColor.color(kColor_Blue)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    }
}


extension UITableView {
    class func tableView() -> UITableView {
        let _tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        _tableView.indicatorStyle = .white
        _tableView.isScrollEnabled = true
        _tableView.isUserInteractionEnabled = true
        _tableView.backgroundColor = UIColor.clear
        _tableView.backgroundView = nil
        _tableView.tableFooterView = UIView.init()
        
        _tableView.sectionHeaderHeight = 0.0
        _tableView.sectionFooterHeight = 0.0
        
        _tableView.separatorStyle = .singleLine
        return _tableView
    }
    
    class func groupTableView() -> UITableView {
        let _tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        _tableView.indicatorStyle = .white
        _tableView.isScrollEnabled = true
        _tableView.isUserInteractionEnabled = true
        _tableView.backgroundColor = UIColor.clear
        _tableView.backgroundView = nil
        _tableView.tableFooterView = UIView.init()
        
        _tableView.sectionHeaderHeight = 0.0
        _tableView.sectionFooterHeight = 0.0
        
        _tableView.separatorStyle = .singleLine
        return _tableView
    }
    
    func scrollToBottom() -> Void {
        let sectionCount:Int = (self.dataSource?.numberOfSections!(in: self))!
        let lastSectionRowCount:Int = (self.dataSource?.tableView(self, numberOfRowsInSection: sectionCount - 1))!
        
        let indexPath: IndexPath = IndexPath.init(row: lastSectionRowCount - 1, section: sectionCount - 1)
        self.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
