//
//  SwiftyRSSFrameworkTests.swift
//  SwiftyRSSFrameworkTests
//
//  Created by Paul Fechner on 4/2/19.
//  Copyright © 2019 PeeJWeeJ. All rights reserved.
//

import Quick
import Nimble
import SWXMLHash

@testable import SwiftyRSSFramework

// Putting these outside of the class so it's not necessary to use `self`
private let config = SWXMLHash.config { (_) in }
private let elementName = "enclosure"

//swiftlint:disable line_length
class RSSEnclosureTests: QuickSpec {

    override func spec() {
        describe("Deserialization") {

            context("WithFullItem") {

                let xmlIndexer = config.parse(fullTestXML)[elementName]
                it("Succeeds") {
                    expect { try xmlIndexer.value() as RSSEnclosure }.toNot(throwError())
                }
                it("IsCorrect") {
                    expect(try? xmlIndexer.value() as RSSEnclosure) == fullItem
                }
            }

            context("WithMissing") {

                describe("URL") {
                    let xmlIndexer = config.parse(missingURLTestXML)[elementName]
                    it("Fails") {
                        expect { try xmlIndexer.value() as RSSEnclosure }.to(throwError())
                    }
                }
                describe("length") {
                    let xmlIndexer = config.parse(missingLengthTestXML)[elementName]
                    it("Fails") {
                        expect { try xmlIndexer.value() as RSSEnclosure }.to(throwError())
                    }
                }
                describe("type") {
                    let xmlIndexer = config.parse(missingTypeTestXML)[elementName]
                    it("Fails") {
                        expect { try xmlIndexer.value() as RSSEnclosure }.to(throwError())
                    }
                }
            }
            context("NoInput") {
                it("Fails") {
                    let xmlIndexer = config.parse("")[elementName]
                    expect { try xmlIndexer.value() as RSSEnclosure }.to(throwError())
                }
            }
        }
    }
}

private let fullItem = RSSEnclosure(url: URL(string: "http://www.scripting.com/mp3s/weatherReportSuite.mp3")!, length: 12216320, type: "audio/mpeg")

private let fullTestXML = """
    <enclosure url="http://www.scripting.com/mp3s/weatherReportSuite.mp3" length="12216320" type="audio/mpeg" />
    """

private let missingURLTestXML = """
<enclosure length="12216320" type="audio/mpeg" />
"""

private let missingLengthTestXML = """
<enclosure url="http://www.scripting.com/mp3s/weatherReportSuite.mp3" type="audio/mpeg" />
"""

private let missingTypeTestXML = """
<enclosure url="http://www.scripting.com/mp3s/weatherReportSuite.mp3" length="12216320"/>
"""

//swiftlint:enable line_length
