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

private let config = SWXMLHash.config { (_) in }
private let elementName = "item"

//swiftlint:disable line_length
class RSSItemTests: QuickSpec {

    override func spec() {

        describe("Deserialization") {

            context("WithFullItem") {

                let xmlIndexer = config.parse(fullTestXML)[elementName]
                it("Succeeds") {
                    expect { try xmlIndexer.value() as RSSItem }.toNot(throwError())
                }
                it("IsCorrect") {
                    let result: RSSItem? = try? xmlIndexer.value()
                    let expected = fullItem
                    expect(result?.title) == expected.title
                    expect(result?.link) == expected.link
                    expect(result?.description) == expected.description
                    expect(result?.author) == expected.author
                    expect(result?.category) == expected.category
                    expect(result?.comments) == expected.comments
                    expect(result?.enclosure) == expected.enclosure
                    expect(result?.guid) == expected.guid
                    expect(result?.pubDate) == expected.pubDate
                    expect(result?.source) == expected.source
                }
            }

            context("WithEmpty") {

                let xmlIndexer = config.parse(emptyTestXML)[elementName]
                it("Succeeds") {
                    expect { try xmlIndexer.value() as RSSItem }.toNot(throwError())
                }
                it("IsCorrect") {
                    let result: RSSItem? = try? xmlIndexer.value()
                    expect(result?.title).to(beNil())
                    expect(result?.link).to(beNil())
                    expect(result?.description).to(beNil())
                    expect(result?.author).to(beNil())
                    expect(result?.category) == []
                    expect(result?.comments).to(beNil())
                    expect(result?.enclosure).to(beNil())
                    expect(result?.guid).to(beNil())
                    expect(result?.pubDate).to(beNil())
                    expect(result?.source).to(beNil())
                }
            }

            context("WithNoInput") {
                it("Fails") {
                    let xmlIndexer = config.parse("")[elementName]
                    expect { try xmlIndexer.value() as RSSItem }.to(throwError())
                }
            }
        }
    }
}

//swiftlint:disable force_try

private let fullItem = RSSItem(title: "RSS Item Title",
                               link: URL(string: "https://www.duckduckgo.com"),
                               description: "An RSS Item",
                               author: "The Author",
                               category: [
                                try! RSSCategory(value: "Duck Duck Go",
                                                 domain: URL(string: "http://www.ddg.com")!)],
                               comments: URL(string: "http://www.ddg.com"),
                               enclosure: RSSEnclosure(url: URL(string:  "http://www.scripting.com/mp3s/weatherReportSuite.mp3")!,
                                                       length: 12216320, type: "audio/mpeg"),
                               guid: "AGuid",
                               pubDate: Date(timeIntervalSince1970: 1031356801),
                               source: try! RSSSource(value: "Tomalak's Realm",
                                                 url: URL(string: "http://www.tomalak.org/links2.xml")!))
//swiftlint:enable force_try

private let fullTestXML = """
<item>
    <title>RSS Item Title</title>
    <link>https://www.duckduckgo.com</link>
    <description>An RSS Item</description>
    <author>The Author</author>
    <category domain="http://www.ddg.com">Duck Duck Go</category>
    <comments>http://www.ddg.com</comments>
    <enclosure url="http://www.scripting.com/mp3s/weatherReportSuite.mp3" length="12216320" type="audio/mpeg" />
    <guid>AGuid</guid>
    <pubDate>Sat, 07 Sep 2002 00:00:01 GMT</pubDate>
    <source url="http://www.tomalak.org/links2.xml">Tomalak's Realm</source>
</item>
"""

let emptyItem = RSSItem(title: nil,
                        link: nil,
                        description: nil,
                        author: nil,
                        category: [],
                        comments: nil,
                        enclosure: nil,
                        guid: nil,
                        pubDate: nil,
                        source: nil)

private let emptyTestXML = """
<item>
</item>
"""

//swiftlint:enable line_length
