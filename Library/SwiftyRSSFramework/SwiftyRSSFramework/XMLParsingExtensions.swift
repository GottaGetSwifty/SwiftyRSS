//
//  XMLParsingExtensions.swift
//  SwiftyRSSFramework
//
//  Created by Paul Fechner on 4/8/19.
//  Copyright © 2019 PeeJWeeJ. All rights reserved.
//

import Foundation
import SWXMLHash

/// Allows interaction using CodingKeys
internal extension XMLElement {

    func value<T: XMLAttributeDeserializable, A: CodingKey>(ofAttribute attr: A) throws -> T {
        return try value(ofAttribute: attr.stringValue)
    }

    func value<T: XMLAttributeDeserializable, A: CodingKey>(ofAttribute attr: A) -> T? {
        return value(ofAttribute: attr.stringValue)
    }
}
