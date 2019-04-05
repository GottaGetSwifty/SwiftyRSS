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

//swiftlint:disable line_length
class RSSSkipDaysTests: QuickSpec {

    override func spec() {

        describe("Deserialization") {

            it("FullItem") {
                if let fullItem: RSSSkipDays = XMLTestHelper.testParseSucceeds(with: XMLTestHelper.parseIntoIndexer(RSSSkipDays.fullTestXML),
                                                                        using: RSSSkipDays.elementName) {
                    expect(fullItem.day) == RSSSkipDays.availableDays
                }
            }
            it("SingleItem") {
                if let fullItem: RSSSkipDays = XMLTestHelper.testParseSucceeds(with: XMLTestHelper.parseIntoIndexer(RSSSkipDays.singleTestXML),
                                                                        using: RSSSkipDays.elementName) {
                    expect(fullItem.day) == [.Sunday]
                }
            }
            it("EmptyItem") {
                if let emptyItem: RSSSkipDays = XMLTestHelper.testParseSucceeds(with: XMLTestHelper.parseIntoIndexer(RSSSkipDays.emptyTestXML),
                                                                        using: RSSSkipDays.elementName) {
                    expect(emptyItem.day.count) == 0
                }
            }
            describe("Has invalid input") {
                it("Ignores Invlid Items") {
                    if let fullItem: RSSSkipDays = XMLTestHelper.testParseSucceeds(with: XMLTestHelper.parseIntoIndexer(RSSSkipDays.extraTestXML),
                                                                           using: RSSSkipDays.elementName) {
                        expect(fullItem.day) == RSSSkipDays.availableDays
                    }
                }
            }
            describe("Fails") {
                it("Has no input") {
                    XMLTestHelper.testParseFailure(with: XMLTestHelper.parseIntoIndexer(""),
                                                   of: RSSSkipHours.self, using: RSSSkipDays.elementName)
                }
            }
        }
    }
}

//swiftlint:enable line_length

private extension RSSSkipDays {

    static var elementName: String {
        return "skipDays"
    }

    static var fullTestXML: String {
        return """
        <skipDays>
            <day>Sunday</day>
            <day>Monday</day>
            <day>Tuesday</day>
            <day>Wednesday</day>
            <day>Thursday</day>
            <day>Friday</day>
            <day>Saturday</day>
        </skipDays>
        """
    }

    static var singleTestXML: String {
        return """
        <skipDays>
            <day>Sunday</day>
        </skipDays>
        """
    }

    static var extraTestXML: String {
        return """
        <skipDays>
            <day>Sunday</day>
            <day>Monday</day>
            <day>Tuesday</day>
            <day>Wednesday</day>
            <day>Thursday</day>
            <day>Friday</day>
            <day>Saturday</day>
            <day>FakeDay</day>
        </skipDays>
        """
    }

    static var emptyTestXML: String {
        return """
        <skipDays>
        </skipDays>
        """
    }

    static var availableDays: [RSSSkipDay] {
        return RSSSkipDay.allCases
    }
}
