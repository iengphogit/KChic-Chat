//
//  EXTCollections.swift
//  KChic-Chat
//
//  Created by Iengpho on 11/9/18.
//  Copyright © 2018 Iengpho. All rights reserved.
//

import UIKit

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
