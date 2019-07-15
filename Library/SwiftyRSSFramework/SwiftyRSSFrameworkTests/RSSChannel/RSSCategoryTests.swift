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
private let elementName = "category"

//swiftlint:disable line_length
class RSSCategoryTests: QuickSpec {

    override func spec() {

        describe("Initialization") {

            context("WithValidInput") {
                it("Succeeds") {
                    expect { try RSSCategory(value: "Duck Duck Go", rawDomain: URL(string: "http://www.ddg.com")!)}.toNot(throwError())
                    expect { try RSSCategory(value: "DDG", domain: nil)}.toNot(throwError())
                }
                it("Matches") {
                    expect { try RSSCategory(value: "Duck Duck Go", rawDomain: URL(string: "http://www.ddg.com")!)} == fullItem
                    expect { try RSSCategory(value: "DDG", domain: nil)} == noURLItem
                }
            }

            context("WithInvalidInput") {
                it("Fails") {
                    expect { try RSSCategory(value: "", rawDomain: URL(string: "http://www.ddg.com")!) }.to(throwError())
                    expect { try RSSCategory(value: "", domain: nil) }.to(throwError())
                }
            }
        }

        describe("Deserialization") {

            context("WithFullItem") {

                let xmlIndexer = config.parse(fullTestXML)[elementName]
                it("Succeeds") {
                    expect { try xmlIndexer.value() as RSSCategory }.toNot(throwError())
                }
                it("IsCorrect") {
                    expect(try? xmlIndexer.value() as RSSCategory) == fullItem
                }
            }

            context("WithOnlyRequiredProperties") {

                let xmlIndexer = config.parse(noURLTestXML)[elementName]
                it("Succeeds") {
                    expect { try xmlIndexer.value() as RSSCategory }.toNot(throwError())
                }
                it("IsCorrect") {
                    expect(try? xmlIndexer.value() as RSSCategory) == noURLItem
                }
            }
            context("WithNoInput") {
                it("Fails") {
                    let xmlIndexer = config.parse("")[elementName]
                    expect { try xmlIndexer.value() as RSSSkipDays }.to(throwError())
                }
            }
        }
    }
}

//swiftlint:disable force_try
private let fullItem = try! RSSCategory(value: "Duck Duck Go", rawDomain: URL(string: "http://www.ddg.com")!)
//swiftlint:enable force_try

private let fullTestXML = """
    <category domain="http://www.ddg.com">Duck Duck Go</category>
    """
//swiftlint:disable force_try
private let noURLItem = try! RSSCategory(value: "DDG", domain: nil)
//swiftlint:enable force_try

private let noURLTestXML = """
    <category>DDG</category>,
    """

private let missingItemsXML = """
    <category></category>
    """

//swiftlint:enable line_length
