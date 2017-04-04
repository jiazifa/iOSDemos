//
//  SSFormRowDescriptor.swift
//  SSFormSwiftDemo
//
//  Created by Mac on 17/3/7.
//  Copyright © 2017年 treee. All rights reserved.
//

import Foundation
import UIKit

private var myContext = 0

/// 点击单元格的回调事件
typealias OnClickedBlock = (_ formRow:SSFormRowDescriptor, _ indexPath:IndexPath) -> Void

/// 在编辑状态下，点击到按钮的回调事件，如果没有实现，就会执行默认的动作
typealias EditingStyleHandle = (_ formRow:SSFormRowDescriptor, _ style:UITableViewCellEditingStyle, _ indexPath:IndexPath) -> Void

class SSFormRowDescriptor: NSObject {
    
    /// 对应单元格的值，对应的cell进行解析
    dynamic var value:AnyObject! {
        didSet(newValue) {
            self.sectionDescriptor?.formDescriptor?.delegate?.formRowDescriptorValueHasChanged(self, newValue: newValue)
        }
    }
    
    /// 单元格的高度
    var height : CGFloat
    
    /// 对应的单元格
    var cell:SSFormBaseCell?
    
    /// 对应的单元格的类型
    var cellClass: AnyClass
    
    /// 单元格的设置
    var cellConfig:[String:AnyObject] = [:]
    
    /// 单元格描述对象对应的区文件
    var sectionDescriptor:SSFormSectionDescriptor?
    
    /// 代理对象
    var delegate:AnyObject?
    
    /// 可以编辑的属性
    var canEditRow:Bool = false {
        didSet {
            let value = self.value
            self.value = value
        }
    }
    
    var canMoveRow:Bool = false {
        didSet {
            let value = self.value
            self.value = value
        }
    }
    /// 编辑的样式(删除/添加)
    var editingStyle:UITableViewCellEditingStyle = .none
    
    ///删除样式的标题
    var titleForDeleteConfirmationButton:String?
    
    ///编辑状态下，侧滑显示的响应集合
    var editActions:[UITableViewRowAction]?
    
    
    /// 在编辑状态下，点击到按钮的回调事件，如果没有实现，就会执行默认的动作
    var editingStyleHandle:EditingStyleHandle?
    
    /// 点击到的回调事件
    var onClickedBlock:OnClickedBlock?
    
    /// 添加的动画效果
    var insertAnimation:UITableViewRowAnimation = .none
    
    /// 删除的动画效果
    var deleteAnimation:UITableViewRowAnimation = .none
    
    /// 刷新的动画效果
    var freshAnimation:UITableViewRowAnimation = .none
    
    /// 点击添加动作，添加一行，如果这个值不为空，那么就会将这一行添加进去
    var addFormRow:SSFormRowDescriptor?
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - height: 高度
    ///   - cellClass: 对应的单元格的类
    ///   - value: 单元格的值
    init(_ height:CGFloat,cellClass:SSFormBaseCell.Type, value:AnyObject) {
        self.height = height
        self.cellClass = cellClass
        self.value = value
        super.init()
        //        self.addObserver(self, forKeyPath: "value", options: [.new,.old], context: &myContext)
    }
    //MARK:-
    //MARK:public
    
    /// 从本区移除
    public func removeFromSection() -> Void {
        self.sectionDescriptor?.removeRow(self)
    }
    
    /// 添加到区
    ///
    /// - Parameter toSection: 添加到的区
    public func addToSection(_ toSection: SSFormSectionDescriptor) -> Void {
        toSection.add(self)
    }
    //MARK:-
    //MARK:hepler
    
    /// 创建一个单元格
    ///
    /// - Returns: 单元格对象
    public func makeCell(_ tableview:SSFormTable) -> SSFormBaseCell? {
        let identifier:String = NSStringFromClass(cellClass)+"ID"
        guard cellClass.isSubclass(of: SSFormBaseCell.self) else {
            return nil
        }
        var cell = tableview.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            tableview.register(cellClass, forCellReuseIdentifier: identifier)
            cell = tableview.dequeueReusableCell(withIdentifier: identifier)
        }
        
        for (key, value) in cellConfig {
            cell?.setValue((value), forKey: key)
        }
        
        return cell as! SSFormBaseCell?
    }
    
    public func editingStyleHandle(_ editing: @escaping EditingStyleHandle) -> Void {
        self.editingStyleHandle = editing
    }
    
    /// 点击单元格的回调
    ///
    /// - Parameter clicked: 点击的回调
    public func onClickHandle(_ clicked: @escaping OnClickedBlock) -> Void {
        self.onClickedBlock = clicked
    }
    //MARK:-
    //MARK:KVO
    
    /// 属性监听，如果改变了就通知代理执行刷新
    /*
     override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
     if self.sectionDescriptor == nil { return}
     if (object as AnyObject).isEqual(self) && keyPath=="value" {
     let newValue:AnyObject = change![.newKey] as AnyObject
     let oldValue:AnyObject = change![.oldKey] as AnyObject
     self.sectionDescriptor?.formDescriptor?.delegate?.formRowDescriptorValueHasChanged(object as! SSFormRowDescriptor, oldValue: oldValue, newValue: newValue)
     }
     }
     
     
     deinit {
     self.removeObserver(self, forKeyPath: "value")
     }
     */
}
