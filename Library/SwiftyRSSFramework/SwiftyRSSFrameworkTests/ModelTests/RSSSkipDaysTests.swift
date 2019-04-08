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
private let elementName = "skipDays"

//swiftlint:disable line_length
class RSSSkipDaysTests: QuickSpec {

    override func spec() {
        describe("Deserialization") {

            context("WithFullItem") {

                let xmlIndexer = config.parse(fullTestXML)[elementName]
                it("Succeeds") {
                    expect { try xmlIndexer.value() as RSSSkipDays }.toNot(throwError())
                }
                it("IsCorrect") {
                    expect((try? xmlIndexer.value() as RSSSkipDays)?.day) == Set(RSSSkipDay.allCases)
                }
            }

            context("SingleItem") {

                let xmlIndexer = config.parse(singleTestXML)[elementName]
                it("Succeeds") {
                    expect { try xmlIndexer.value() as RSSSkipDays }.toNot(throwError())
                }
                it("IsCorrect") {
                    expect((try? xmlIndexer.value() as RSSSkipDays)?.day) == [.Sunday]
                }
            }

            context("EmptyItem") {

                let xmlIndexer = config.parse(emptyTestXML)[elementName]
                it("Succeeds") {
                    expect { try xmlIndexer.value() as RSSSkipDays }.toNot(throwError())
                }
                it("IsCorrect") {
                    expect((try? xmlIndexer.value() as RSSSkipDays)?.day.count) == 0
                }
            }

            describe("HasInvalidInput") {
                context("InvalidItems") {
                    let xmlIndexer = config.parse(extraItemTestXML)[elementName]
                    it("Succeeds") {
                        expect { try xmlIndexer.value() as RSSSkipDays }.toNot(throwError())
                    }
                    it("IsCorrect") {
                        expect((try? xmlIndexer.value() as RSSSkipDays)?.day) == Set(RSSSkipDay.allCases)
                    }
                }
                context("NotInput") {
                    it("Fails") {
                        let xmlIndexer = config.parse("")[elementName]
                        expect { try xmlIndexer.value() as RSSSkipDays }.to(throwError())
                    }
                }
            }
        }
    }
}

//swiftlint:enable line_length

private let fullTestXML = """
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

private let singleTestXML = """
    <skipDays>
        <day>Sunday</day>
    </skipDays>
    """

private let extraItemTestXML = """
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

private let emptyTestXML = """
    <skipDays>
    </skipDays>
    """
