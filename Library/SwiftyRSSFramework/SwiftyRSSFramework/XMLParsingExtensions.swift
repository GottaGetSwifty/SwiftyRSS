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

/// Allows interaction using CodingKeys
internal extension XMLIndexer {
    /**
     Find an XML element at the current level by element name

     - parameter key: The element name to index by
     - returns: instance of XMLIndexer to match the element (or elements) found by
     */
    subscript<A: CodingKey>(key: A) -> XMLIndexer {
        return self[key.stringValue]
    }

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `T`

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `T` value
     */
    func value<A: CodingKey, T: XMLAttributeDeserializable>(ofAttribute attr: A) throws -> T {
        return try value(ofAttribute: attr.stringValue)
    }
}
