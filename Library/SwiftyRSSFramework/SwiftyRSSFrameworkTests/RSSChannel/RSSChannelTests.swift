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
private let elementName = "channel"

//swiftlint:disable line_length
//swiftlint:disable function_body_length
class RSSChannelTests: QuickSpec {

    override func spec() {

        describe("Deserialization") {

            context("WithFullItem") {

                let xmlIndexer = config.parse(fullTestXML)[elementName]
                it("Succeeds") {
                    expect { try xmlIndexer.value() as RSSChannel }.toNot(throwError())
                }
                it("IsCorrect") {
                    let result: RSSChannel? = try? xmlIndexer.value()
                    let expected = fullItem
                    expect(result?.title) == expected.title
                    expect(result?.link) == expected.link
                    expect(result?.description) == expected.description
                    expect(result?.language) == expected.language
                    expect(result?.copyright) == expected.copyright
                    expect(result?.managingEditor) == expected.managingEditor
                    expect(result?.webMaster) == expected.webMaster
                    expect(result?.pubDate) == expected.pubDate
                    expect(result?.lastBuildDate) == expected.lastBuildDate
                    expect(result?.category) == expected.category
                    expect(result?.generator) == expected.generator
                    expect(result?.docs) == expected.docs
                    expect(result?.cloud) == expected.cloud
                    expect(result?.ttl) == expected.ttl
                    expect(result?.image) == expected.image
                    expect(result?.rating) == expected.rating
                    expect(result?.textInput) == expected.textInput
                    expect(result?.skipHours) == expected.skipHours
                    expect(result?.skipDays) == expected.skipDays
                }
            }

            context("WithOnlyRequiredProperties") {

                let xmlIndexer = config.parse(onlyRequiredItemsTestXML)[elementName]
                it("Succeeds") {
                    expect { try xmlIndexer.value() as RSSChannel }.toNot(throwError())
                }
                it("IsCorrect") {
                    let result: RSSChannel? = try? xmlIndexer.value()
                    let expected = onlyRequiredItem
                    expect(result?.title) == expected.title
                    expect(result?.link) == expected.link
                    expect(result?.description) == expected.description
                    expect(result?.language).to(beNil())
                    expect(result?.copyright).to(beNil())
                    expect(result?.managingEditor).to(beNil())
                    expect(result?.webMaster).to(beNil())
                    expect(result?.pubDate).to(beNil())
                    expect(result?.lastBuildDate).to(beNil())
                    expect(result?.category) == []
                    expect(result?.generator).to(beNil())
                    expect(result?.docs).to(beNil())
                    expect(result?.cloud).to(beNil())
                    expect(result?.ttl).to(beNil())
                    expect(result?.image).to(beNil())
                    expect(result?.rating).to(beNil())
                    expect(result?.textInput).to(beNil())
                    expect(result?.skipHours).to(beNil())
                    expect(result?.skipDays).to(beNil())
                }
            }
            context("WithMissing") {

                describe("Title") {
                    let xmlIndexer = config.parse(missingTitleTestXML)[elementName]
                    it("Fails") {
                        expect { try xmlIndexer.value() as RSSTextInput }.to(throwError())
                    }
                }
                describe("Name") {
                    let xmlIndexer = config.parse(missingLinkTestXML)[elementName]
                    it("Fails") {
                        expect { try xmlIndexer.value() as RSSTextInput }.to(throwError())
                    }
                }
                describe("Description") {
                    let xmlIndexer = config.parse(missingDescriptionTestXML)[elementName]
                    it("Fails") {
                        expect { try xmlIndexer.value() as RSSTextInput }.to(throwError())
                    }
                }
            }

            context("WithNoInput") {
                it("Fails") {
                    let xmlIndexer = config.parse("")[elementName]
                    expect { try xmlIndexer.value() as RSSChannel }.to(throwError())
                }
            }
        }
    }
}
//swiftlint:enable function_body_length

//swiftlint:disable force_try

private let fullItem = RSSChannel(title: "Test Channel",
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
                                  skipDays: RSSSkipDays(day: Set(RSSSkipDay.allCases)))
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
</channel>
"""

private let onlyRequiredItem = RSSChannel(title: "Test Channel",
                                          link: URL(string: "https://www.duckduckgo.com")!,
                                          description: "Test RSS Channel",
                                          language: nil, copyright: nil, managingEditor: nil, webMaster: nil,
                                          pubDate: nil, lastBuildDate: nil, category: [], generator: nil,
                                          docs: nil, cloud: nil, ttl: nil, image: nil, rating: nil, textInput: nil,
                                          skipHours: nil, skipDays: nil  )

private let onlyRequiredItemsTestXML = """
<channel>
    <title>Test Channel</title>
    <link>https://www.duckduckgo.com</link>
    <description>Test RSS Channel</description>
</channel>
"""

private let missingTitleTestXML = """
<channel>
    <link>https://www.test.com</link>
    <description>Test RSS Channel</description>
</channel>
"""

private let missingLinkTestXML = """
<channel>
    <title>Test Channel</title>
    <description>Test RSS Channel</description>
</channel>
"""

private let missingDescriptionTestXML = """
<channel>
    <title>Test Channel</title>
    <link>https://www.test.com</link>
</channel>
"""

//swiftlint:enable line_length
