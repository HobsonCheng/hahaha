//
//  OrderViewModel.swift
//  UIDS
//
//  Created by one2much on 2018/1/26.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources


public enum OrderViewModelType {
    case grap                             // 抢单
    case oning                             // 正在进行
    case over                          // 完成
}

class OrderViewModel: NSObject {
    
    var orderList: [OrderCData]?
    
    
    func getGarp(params: NSMutableDictionary,callback: @escaping (_ obj: Observable<[SectionModel<String, OrderCData>]>)->()){

        let paramsAll = NSMutableDictionary()
        paramsAll.setObject("1", forKey: "page" as NSCopying)
        paramsAll.setObject("30", forKey: "page_context" as NSCopying)

        ApiUtil.share.getWaitSubscribeList(params: paramsAll) {[weak self] (status, data, msg) in

            self?.orderList = OrderCModel.deserialize(from: data)?.data
            
            let obj = Observable<[SectionModel<String, OrderCData>]>.create({ (observer) -> Disposable in

                let section = [SectionModel(model: "", items: (self?.orderList)!)]
                observer.onNext(section)
                observer.onCompleted()
                
                return Disposables.create()
                
            })
            callback(obj)
        }
    }
    
    func getOrderList(params: NSMutableDictionary,callback: @escaping (_ obj: Observable<[SectionModel<String, OrderCData>]>)->()){
        
        ApiUtil.share.getUserSubscribeList(params: params) {[weak self] (status, data, msg) in
            
            self?.orderList = OrderCModel.deserialize(from: data)?.data

            let obj = Observable<[SectionModel<String, OrderCData>]>.create({ (observer) -> Disposable in
                
                if self?.orderList?.count != 0 {
                    let section = [SectionModel(model: "", items: (self?.orderList)!)]
                    observer.onNext(section)
                }
                
                observer.onCompleted()
            
                return Disposables.create()
                
            })
            callback(obj)
        }
    }
    
    
    
}


struct OrderSection {
    
    var items: [Item]
}

extension OrderSection: SectionModelType {
    typealias Item = OrderCData
    
    init(original: OrderSection, items: [OrderCData]) {
        self = original
        self.items = items
    }
}

