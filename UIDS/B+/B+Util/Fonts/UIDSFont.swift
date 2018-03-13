//
//  UIDSFont.swift
//  UIDS
//
//  Created by Hobson on 2018/3/13.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation

//enum UIDSType : Int{
//    static var count : Int{
//        return UIDSIcons.count
//    }
//
//    public var text:String?{
//        return UIDSIcons[rawValue]
//    }
//    case
//}

private let UIDSIcons = ["\u{e634}","\u{e62d}","\u{e61a}","\u{e68d}","\u{e6b8}",
                         "\u{e68e}","\u{e60b}","\u{e695}","\u{e623}","\u{e627}",
                         "\u{ea21}","\u{e626}","\u{e651}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}","\u{e62d}",
                         "\u{e62d}","\u{e634}","\u{e62d}","\u{e62d}"]
