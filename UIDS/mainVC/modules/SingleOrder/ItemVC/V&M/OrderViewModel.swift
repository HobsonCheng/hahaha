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
    
    func getGarp(params: NSMutableDictionary,callback: @escaping (_ obj: Observable<[SectionModelType]>)->()){
        
        let paramsAll = NSMutableDictionary()
        paramsAll.setObject("1", forKey: "page" as NSCopying)
        paramsAll.setObject("30", forKey: "page_context" as NSCopying)
        
        ApiUtil.share.getWaitSubscribeList(params: paramsAll) { (status, data, msg) in
        
            let obj = Observable<[SectionModelType]>.create({ (observer) -> Disposable in
                
//                let datas = OrderCModel.deserialize(from: data)?.data
//
//                let section = OrderSection.init(items: datas!)
//
                let list = [OrderCellModel(),OrderCellModel(),OrderCellModel(),OrderCellModel(),OrderCellModel()]
                
                let section = [SectionModel(model: "", items: list)]
                
                observer.onNext(section)
                observer.onCompleted()
            
                return Disposables.create()
            })
            callback(obj)
        }
    
    }
}

