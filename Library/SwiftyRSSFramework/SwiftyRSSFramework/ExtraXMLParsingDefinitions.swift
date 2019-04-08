//
//  ExtraXMLParsingDefinitions.swift
//  SwiftyRSSFramework
//
//  Created by Paul Fechner on 4/8/19.
//  Copyright © 2019 PeeJWeeJ. All rights reserved.
//

import Foundation
import SWXMLHash

private let standardDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
    return formatter
}()

/// Date XML deserialization using the standardDateFormatter (using [RFC822](https://www.w3.org/Protocols/rfc822/)
extension Date: XMLElementDeserializable, XMLAttributeDeserializable {

    public static func deserialize(_ element: XMLElement) throws -> Date {
        guard let date = standardDateFormatter.date(from: element.text) else {
            throw XMLDeserializationError.typeConversionFailed(type: "Date", element: element)
        }
        return date
    }

    public static func deserialize(_ attribute: XMLAttribute) throws -> Date {
        guard let date = standardDateFormatter.date(from: attribute.text) else {
            throw XMLDeserializationError.attributeDeserializationFailed(type: "Date", attribute: attribute)
        }
        return date
    }
}

/// URL XML deserialization for URLs
extension URL: XMLElementDeserializable, XMLAttributeDeserializable {

    public static func deserialize(_ element: XMLElement) throws -> URL {
        guard let url = URL(string: element.text) else {
            throw XMLDeserializationError.typeConversionFailed(type: "URL", element: element)
        }
        return url
    }

    public static func deserialize(_ attribute: XMLAttribute) throws -> URL {
        guard let url = URL(string: attribute.text) else {
            throw XMLDeserializationError.attributeDeserializationFailed(type: "URL", attribute: attribute)
        }
        return url
    }
}
