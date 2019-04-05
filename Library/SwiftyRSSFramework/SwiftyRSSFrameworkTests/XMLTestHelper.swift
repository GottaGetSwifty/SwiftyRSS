//
//  XMLTestHelper.swift
//  SwiftyRSSFrameworkTests
//
//  Created by Paul Fechner on 4/2/19.
//  Copyright © 2019 PeeJWeeJ. All rights reserved.
//

import Quick
import Nimble
import SWXMLHash

class XMLTestHelper {

    static func parseIntoIndexer(_ xmlText: String) -> XMLIndexer {
        let indexer = SWXMLHash.config { (_) in }.parse(xmlText)
        return indexer
    }

    static func parseIntoElement(_ xmlText: String) -> XMLElement {
        let indexer = SWXMLHash.config { (_) in }.parse(xmlText).element!
        return indexer
    }

    static func testParseSucceeds<T: XMLIndexerDeserializable>(with indexer: XMLIndexer, using key: String) -> T? {
        let failureMessage = "Could not parse \(T.self). Additional tests will be skipped"
        expect {
            let thing: T = try indexer[key].value()
            return thing
            }.toNot(throwError(), description: failureMessage)
        return try? indexer[key].value()
    }

    static func testParseFailure<T: XMLIndexerDeserializable>(with indexer: XMLIndexer,
                                                              of type: T.Type,
                                                              using key: String) {
        let failureMessage = "Parsed invalid data of Type \(T.self)"
        expect {
            let thing: T = try indexer[key].value()
            return thing
            }.to(throwError(), description: failureMessage)

    }
}
