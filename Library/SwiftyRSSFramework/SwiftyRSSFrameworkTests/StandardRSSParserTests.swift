//
//  RSSParserTests.swift
//  SwiftyRSSFramework
//
//  Created by Paul Fechner on 4/14/19.
//Copyright © 2019 PeeJWeeJ. All rights reserved.
//

import Quick
import Nimble

@testable import SwiftyRSSFramework

//swiftlint:disable function_body_length
class StandardRSSParserTests: QuickSpec {

    override func spec() {

        describe("SynchronousDeserialization") {

            describe("WithValidInput") {

                let serializationResult = StandardRSSParser.parseSynchronously(data: fullTestXML.data(using: .utf8)!)
                it("Succeeds") {
                    expect({
                        switch serializationResult {
                        case .failure(let error):
                            return .failed(reason: "Error: \(error.localizedDescription)")
                        case .success:
                            return .succeeded
                        }
                    }).to(succeed())
                    expect(try? serializationResult.get()).toNot(beNil())
                }
                describe("Matches") {

                    let result = try? serializationResult.get()
                    let expected = fullItem

                    it("Channel") {
                        expect(result?.channel.title) == expected.channel.title
                        expect(result?.channel.link) == expected.channel.link
                        expect(result?.channel.description) == expected.channel.description
                        expect(result?.channel.language) == expected.channel.language
                        expect(result?.channel.copyright) == expected.channel.copyright
                        expect(result?.channel.managingEditor) == expected.channel.managingEditor
                        expect(result?.channel.webMaster) == expected.channel.webMaster
                        expect(result?.channel.pubDate) == expected.channel.pubDate
                        expect(result?.channel.lastBuildDate) == expected.channel.lastBuildDate
                        expect(result?.channel.category) == expected.channel.category
                        expect(result?.channel.generator) == expected.channel.generator
                        expect(result?.channel.docs) == expected.channel.docs
                        expect(result?.channel.cloud) == expected.channel.cloud
                        expect(result?.channel.ttl) == expected.channel.ttl
                        expect(result?.channel.image) == expected.channel.image
                        expect(result?.channel.rating) == expected.channel.rating
                        expect(result?.channel.textInput) == expected.channel.textInput
                        expect(result?.channel.skipHours) == expected.channel.skipHours
                        expect(result?.channel.skipDays) == expected.channel.skipDays
                    }
                    it("Item") {
                        expect(result?.item.count) == 1

                        expect(result?.item.first?.title) == expected.item.first?.title
                        expect(result?.item.first?.link) == expected.item.first?.link
                        expect(result?.item.first?.description) == expected.item.first?.description
                        expect(result?.item.first?.author) == expected.item.first?.author
                        expect(result?.item.first?.category) == expected.item.first?.category
                        expect(result?.item.first?.comments) == expected.item.first?.comments
                        expect(result?.item.first?.enclosure) == expected.item.first?.enclosure
                        expect(result?.item.first?.guid) == expected.item.first?.guid
                        expect(result?.item.first?.pubDate) == expected.item.first?.pubDate
                        expect(result?.item.first?.source) == expected.item.first?.source
                    }
                }
            }

            describe("WithInvalidInput") {
                let serializationResult = StandardRSSParser.parseSynchronously(data: emptyTestXML.data(using: .utf8)!)
                it("Fails") {
                    expect({
                        switch serializationResult {
                        case .failure(let error):
                            return .failed(reason: "Error: \(error.localizedDescription)")
                        case .success:
                            return .succeeded
                        }
                    }).toNot(succeed())
                }
            }
        }

        describe("ASynchronousDeserialization") {
            context("WithCustomQueue") {
                it("Succeeds") {
                    var subjectFeed: StandardRSSFeed?
                    StandardRSSParser.parse(data: fullTestXML.data(using: .utf8)!,
                                            completionQueue: .global(), completion: {
                                                subjectFeed = try? $0.get()
                                            })
                    expect(subjectFeed).toEventuallyNot(beNil())
                }
            }
            context("WithStandardQueue") {
                it("Succeeds") {
                    var subjectFeed: StandardRSSFeed?
                    StandardRSSParser.parse(data: fullTestXML.data(using: .utf8)!, completion: {
                        subjectFeed = try? $0.get()
                    })
                    expect(subjectFeed).toEventuallyNot(beNil())
                }
            }
        }
    }
}
//swiftlint:enable function_body_length

//swiftlint:disable force_try
//swiftlint:disable line_length
private let fullItem = StandardRSSFeed(
    channel: RSSChannel(title: "Test Channel",
                       link: URL(string: "https://www.duckduckgo.com")!,
                       description: "Test RSS Channel",
                       language: "en_us",
                       copyright: "2019, Me",
                       managingEditor: "Someone",
                       webMaster: "Someone Else",
                       pubDate: Date(timeIntervalSince1970: 1031356801),
                       lastBuildDate: Date(timeIntervalSince1970: 1031356802),
                       category: [try! RSSCategory(value: "Duck Duck Go", domain: URL(string: "http://www.ddg.com")!),
                                  try! RSSCategory(value: "Google", domain: URL(string: "http://www.google.com")!)],
                       generator: "A Generator",
                       docs: URL(string: "https://www.bing.com")!,
                       cloud: RSSCloud(domain: "radio.xmlstoragesystem.com", port: "80", path: "/RPC2", registerProcedure: "xmlStorageSystem.rssPleaseNotify", protocol: "xml-rpc"),
                       ttl: 60,
                       image: RSSImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/fi/8/88/DuckDuckGo_logo.svg")!,
                                       title: "Duck Duck Go", link: URL(string: "https://www.ddg.com")!,
                                       width: 200, height: 100,
                                       description: "DDG Search Engine"),
                       rating: "A PICS rating",
                       textInput: RSSTextInput(title: "Search",
                                               description: "Search Google",
                                               name: "q",
                                               link: URL(string: "http://www.google.com/search?")!),
                       skipHours: try! RSSSkipHours(hour: Array(0...23)),
                       skipDays: RSSSkipDays(day: Set(RSSSkipDay.allCases))),
    item: [
        RSSItem(title: "RSS Item Title",
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
                source: try! RSSSource(value: "Tomalak's Realm", url: URL(string: "http://www.tomalak.org/links2.xml")!))
    ])

//swiftlint:enable force_try
private let fullTestXML = """
<channel>
    <title>Test Channel</title>
    <link>https://www.duckduckgo.com</link>
    <description>Test RSS Channel</description>
    <language>en_us</language>
    <copyright>2019, Me</copyright>
    <managingEditor>Someone</managingEditor>
    <webMaster>Someone Else</webMaster>
    <pubDate>Sat, 07 Sep 2002 00:00:01 GMT</pubDate>
    <lastBuildDate>Sat, 07 Sep 2002 00:00:02 GMT</lastBuildDate>
    <category domain="http://www.ddg.com">Duck Duck Go</category>
    <category domain="http://www.google.com">Google</category>
    <generator>A Generator</generator>
    <docs>https://www.bing.com</docs>
    <cloud domain="radio.xmlstoragesystem.com" port="80" path="/RPC2" registerProcedure="xmlStorageSystem.rssPleaseNotify" protocol="xml-rpc" />
    <ttl>60</ttl>
    <image>
        <url>https://upload.wikimedia.org/wikipedia/fi/8/88/DuckDuckGo_logo.svg</url>
        <title>Duck Duck Go</title>
        <link>https://www.ddg.com</link>
        <width>200</width>
        <height>100</height>
        <description>DDG Search Engine</description>
    </image>
    <rating>A PICS rating</rating>
    <textInput>
        <title>Search</title>
        <description>Search Google</description>
        <name>q</name>
        <link>http://www.google.com/search?</link>
    </textInput>
     <skipHours>
        <hour>0</hour>
        <hour>1</hour>
        <hour>2</hour>
        <hour>3</hour>
        <hour>4</hour>
        <hour>5</hour>
        <hour>6</hour>
        <hour>7</hour>
        <hour>8</hour>
        <hour>9</hour>
        <hour>10</hour>
        <hour>11</hour>
        <hour>12</hour>
        <hour>13</hour>
        <hour>14</hour>
        <hour>15</hour>
        <hour>16</hour>
        <hour>17</hour>
        <hour>18</hour>
        <hour>19</hour>
        <hour>20</hour>
        <hour>21</hour>
        <hour>22</hour>
        <hour>23</hour>
    </skipHours>
    <skipDays>
        <day>Sunday</day>
        <day>Monday</day>
        <day>Tuesday</day>
        <day>Wednesday</day>
        <day>Thursday</day>
        <day>Friday</day>
        <day>Saturday</day>
    </skipDays>
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
</channel>
"""

private let emptyTestXML = """
<channel>
</channel>
"""

//swiftlint:enable line_length
