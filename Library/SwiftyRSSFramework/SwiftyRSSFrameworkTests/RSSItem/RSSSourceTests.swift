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
private let elementName = "source"

//swiftlint:disable line_length

class RSSSourceTests: QuickSpec {

    override func spec() {
        describe("Deserialization") {

            describe("Initialization") {

                context("WithValidInput") {
                    it("Succeeds") {
                        expect { try RSSSource(value: "Tomalak's Realm",
                                               rawURL: URL(string:"http://www.tomalak.org/links2.xml")!) }.toNot(throwError())
                    }
                    it("Matches") {
                        expect(try?  RSSSource(value: "Tomalak's Realm",
                                               rawURL: URL(string:"http://www.tomalak.org/links2.xml")!)
                            ) == fullItem
                    }
                }

                context("WithInvalidInput") {
                    it("Fails") {
                        expect { try RSSSource(value: "",
                                               rawURL: URL(string:"http://www.tomalak.org/links2.xml")!) }.to(throwError())
                    }
                }
            }

            context("WithFullItem") {

                let xmlIndexer = config.parse(fullTestXML)[elementName]
                it("Succeeds") {
                    expect { try xmlIndexer.value() as RSSSource }.toNot(throwError())
                }
                it("IsCorrect") {
                    expect(try? xmlIndexer.value() as RSSSource) == fullItem
                }
            }

            context("MissingURL") {

                let xmlIndexer = config.parse(missingURLTestXML)[elementName]
                it("Fails") {
                    expect { try xmlIndexer.value() as RSSSource }.to(throwError())
                }
            }
            context("NoInput") {

                it("Fails") {
                    let xmlIndexer = config.parse("")[elementName]
                    expect { try xmlIndexer.value() as RSSSource }.to(throwError())
                }
            }
        }
    }
}
//swiftlint:disable force_try
private let fullItem = try! RSSSource(value: "Tomalak's Realm",
                                      rawURL: URL(string:"http://www.tomalak.org/links2.xml")!)
//swiftlint:enable force_try

private let fullTestXML = """
    <source url="http://www.tomalak.org/links2.xml">Tomalak's Realm</source>
    """

private let missingURLTestXML = """
<source>Tomalak's Realm</source>
"""

private let missingValueXML = """
    <source url="http://www.tomalak.org/links2.xml"></source>
    """

//swiftlint:enable line_length
