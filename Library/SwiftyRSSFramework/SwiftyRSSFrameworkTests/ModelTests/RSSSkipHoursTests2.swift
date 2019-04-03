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
class RSSSkipHoursTests2: QuickSpec {

    override func spec() {

        describe("Deserialization") {

            RSSSkipHours.runBasicTests()
            describe("Failes") {
                RSSSkipHours.runThrowingTests()
            }

//
//            it("FullItem") {
//                if let fullItem: RSSSkipHours = XMLTestHelper.testParse(with: XMLTestHelper.parseIntoIndexer(RSSSkipHours.fullTestXML),
//                                                                        using: RSSSkipHours.elementName) {
//                    expect(fullItem.hour) == RSSSkipHours.availableHours
//                }
//            }
//            it("SingleItem") {
//                if let fullItem: RSSSkipHours = XMLTestHelper.testParse(with: XMLTestHelper.parseIntoIndexer(RSSSkipHours.singleTestXML),
//                                                                        using: RSSSkipHours.elementName) {
//                    expect(fullItem.hour) == [1]
//                }
//            }
//            it("EmptyItem") {
//                if let emptyItem: RSSSkipHours = XMLTestHelper.testParse(with: XMLTestHelper.parseIntoIndexer(RSSSkipHours.emptyTestXML),
//                                                                        using: RSSSkipHours.elementName) {
//                    expect(emptyItem.hour.count) == 0
//                }
//            }
//            describe("Fails") {
//                it("Has invalid input") {
//                    XMLTestHelper.testParseFailure(with: XMLTestHelper.parseIntoIndexer(RSSSkipHours.extraTestXML),
//                                                   of: RSSSkipHours.self, using: RSSSkipHours.elementName)
//                }
//                it("Has no input") {
//                    XMLTestHelper.testParseFailure(with: XMLTestHelper.parseIntoIndexer(""),
//                                                   of: RSSSkipHours.self, using: RSSSkipHours.elementName)
//                }
//            }
        }
    }
}

//swiftlint:enable line_length

struct XMLTestValue<T> {
    let itText: String
    let xmlText: String
    let expectedValue: T?
}

private protocol RSSTestable: Equatable, XMLIndexerDeserializable {
    static var elementName: String { get }
    static var testValues: [XMLTestValue<Self>] { get }
    static var throwingValues: [XMLTestValue<Self>] { get }
}

extension RSSTestable {
    static func runBasicTests() {
        testValues.forEach { testValue in
            it(testValue.itText) {
                if let fullItem: Self = XMLTestHelper.testParse(with: XMLTestHelper.parseIntoIndexer(testValue.xmlText),
                                                                using: elementName) {
                    expect(fullItem) == testValue.expectedValue
                }
            }
        }
    }

    static func runThrowingTests() {
        throwingValues.forEach { testValue in
            it(testValue.itText) {
                XMLTestHelper.testParseFailure(with: XMLTestHelper.parseIntoIndexer(testValue.xmlText),
                                               of: Self.self, using: elementName)
            }
        }
    }
}

extension RSSSkipHours: RSSTestable {

    static var elementName: String {
        return "skipHours"
    }

    static var testValues: [XMLTestValue<RSSSkipHours>] {
        return [fullTestValues, singleTestValues, emptyTestValues]
    }

    static var throwingValues: [XMLTestValue<RSSSkipHours>] {
        return [extraTestValues, noValueTestValues]
    }

    static var fullTestValues: XMLTestValue<RSSSkipHours> {
        return XMLTestValue(itText: "FullItem", xmlText: fullTestXML, expectedValue: RSSSkipHours(hour: availableHours))
    }
    static var singleTestValues: XMLTestValue<RSSSkipHours> {
        return XMLTestValue(itText: "SingleItem", xmlText: singleTestXML, expectedValue: RSSSkipHours(hour: [1]))
    }
    static var emptyTestValues: XMLTestValue<RSSSkipHours> {
        return XMLTestValue(itText: "EmptyItem", xmlText: emptyTestXML, expectedValue: RSSSkipHours(hour: []))
    }

    static var extraTestValues: XMLTestValue<RSSSkipHours> {
        return XMLTestValue(itText: "Has invalid input", xmlText: extraTestXML, expectedValue: nil)
    }
    static var noValueTestValues: XMLTestValue<RSSSkipHours> {
        return XMLTestValue(itText: "Has no input", xmlText: "", expectedValue: nil)
    }

    static var fullTestXML: String {
        return """
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
        """
    }

    static var singleTestXML: String {
        return """
        <skipHours>
            <hour>1</hour>
        </skipHours>
        """
    }

    static var extraTestXML: String {
        return """
        <skipHours>
            <hour>0</hour>
            <hour>1</hour>
            <hour>2</hour>
            <hour>3</hour>
            <hour>4</hour>
            <hour>5</hour>
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
            <hour>24</hour>
        </skipHours>
        """
    }

    static var emptyTestXML: String {
        return """
        <skipHours>
        </skipHours>
        """
    }

    static var availableHours: [Int] {
        return [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
    }
}
