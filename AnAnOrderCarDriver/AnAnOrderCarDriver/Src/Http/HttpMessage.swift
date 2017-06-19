//
//  HttpMessage.swift
//  AnAnOrderCarDriver
//
//  Created by Mac on 17/3/17.
//  Copyright © 2017年 treee. All rights reserved.
//

import Foundation
import Alamofire
// MARK: - 提供一些常用的方法,用于快速创建对象
extension HttpMessage {
    func defaultJSONHeaders() -> [String: String] {
        return ["Content-Type": "application/json"]
    }
}


class HttpMessage {
    //MARK:-
    //MARK:sending

    //发送的代码类型
    var cmdCode : E_CMDCODE = .CC_Default
    //请求超时
    var timeout : Float = 15.0
    //请求的地址
    var requestUrl : String = ""
    //请求的参数
    var parame : [String: Any]?
    /// 请求头信息(can be nil)
    var headers: [String: String]?
    //请求的方法
    var requestMethod : HTTPMethod = .get
    //添加的用户信息(can be nil)
    var userInfo : AnyObject?
    //二进制流 e.g. 图片数据
    var postData : Data = Data.init()
    //能否传输图片
    var isUploadImage : Bool = false
    //请求回调
    var delegate : HttpResponseDelegate?
    
    /// 请求的参数类型。默认是Alamofire默认的参数。有的情况会需要json的类型，可以修改这里
    var paramsEncoding : ParameterEncoding = URLEncoding.default
    
    //MARK:-
    //MARK:recieving

    //错误码
    var errorCode : Int = 0
    //回应的字符
    var responseString : String = ""
    //返回的json数据
    var jsonItems : [String:Any] = [:]
    //请求能否可以多个并行
    var canMultipleConCurrent : Bool = false
    //追加的cookies
    var addedCookies : NSMutableArray = NSMutableArray.init()
    //返回的状态码
    var responseStatusCode : Int = 0
    //请求的错误
    var error : Error?
    //添加的数值
    var additionValues : NSMutableDictionary = NSMutableDictionary.init()
    
    func setup() {
        self.requestMethod = .get
    }
    
    init(url:String = "", postDic:NSDictionary = NSDictionary(), delegate:HttpResponseDelegate? = nil, cmdCode:E_CMDCODE = E_CMDCODE.CC_Default) {
        setup()
        self.requestUrl = url
        self.cmdCode = cmdCode
        self.delegate = delegate
    }
    
    public func cancelDelegate() -> Void {
        delegate = nil
    }
    func cancelDelegateAndCancel() -> Void {
        cancelDelegate()
        
    }
}
/*!
 @protocol       HttpResponseDelegate
 @abstract       HttpMessage的一个代理
 @discussion     代理模式
 */
protocol HttpResponseDelegate {
    /*!
     @method        receiveDidFinished
     @abstract      请求完成（请求有返回）后的回调方法
     @discussion    代理类中实现
     @param         receiveMsg  HttpMessage对象
     */
    func receiveDidFinished(receiveMsg:HttpMessage) -> Void;
    /*!
     @method        receiveDidFailed
     @abstract      请求失败（超时，网络未链接等错误）后的回调方法
     @discussion    代理类中实现
     @param         receiveMsg  HttpMessage对象
     */
    func receiveDidFailed(receiveMsg:HttpMessage) -> Void;
}

