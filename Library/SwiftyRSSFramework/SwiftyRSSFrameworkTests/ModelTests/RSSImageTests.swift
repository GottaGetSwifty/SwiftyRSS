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
private let elementName = "image"

//swiftlint:disable line_length
class RSSImageTests: QuickSpec {

    override func spec() {
        describe("Deserialization") {

            context("WithFullItem") {

                let xmlIndexer = config.parse(fullTestXML)[elementName]
                it("Succeeds") {
                    expect { try xmlIndexer.value() as RSSImage }.toNot(throwError())
                }
                it("IsCorrect") {
                    expect(try? xmlIndexer.value() as RSSImage) == fullItem
                }
            }

            context("OnlyRequiredProperties") {

                let xmlIndexer = config.parse(onlyRequiredItemsTestXML)[elementName]
                it("Succeeds") {
                    expect { try xmlIndexer.value() as RSSImage }.toNot(throwError())
                }
                it("IsCorrect") {
                    expect(try? xmlIndexer.value() as RSSImage) == onlyRequiredItems
                }
            }
            context("MissingRequiredElements") {
                let xmlIndexer = config.parse(missingItemsXML)[elementName]
                it("Fails") {
                    expect { try xmlIndexer.value() as RSSImage }.to(throwError())
                }
            }
            context("NoInput") {
                it("Fails") {
                    let xmlIndexer = config.parse("")[elementName]
                    expect { try xmlIndexer.value() as RSSSkipDays }.to(throwError())
                }
            }
        }
    }
}

private let fullItem = RSSImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/fi/8/88/DuckDuckGo_logo.svg")!,
                                title: "Duck Duck Go", link: URL(string: "https://www.ddg.com")!,
                                width: 200, height: 100,
                                description: "DDG Search Engine")

private let fullTestXML = """
    <image>
        <url>https://upload.wikimedia.org/wikipedia/fi/8/88/DuckDuckGo_logo.svg</url>
        <title>Duck Duck Go</title>
        <link>https://www.ddg.com</link>
        <width>200</width>
        <height>100</height>
        <description>DDG Search Engine</description>
    </image>
    """

private let onlyRequiredItems = RSSImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/fi/8/88/DuckDuckGo_logo.svg")!,
                                            title: "Duck Duck Go",
                                            link: URL(string: "https://www.ddg.com")!,
                                            width: nil, height: nil,
                                            description: nil)
private let onlyRequiredItemsTestXML = """
    <image>
        <url>https://upload.wikimedia.org/wikipedia/fi/8/88/DuckDuckGo_logo.svg</url>
        <title>Duck Duck Go</title>
        <link>https://www.ddg.com</link>
    </image>
    """

private let missingItemsXML = """
    <image>
    </image>
    """

//swiftlint:enable line_length
