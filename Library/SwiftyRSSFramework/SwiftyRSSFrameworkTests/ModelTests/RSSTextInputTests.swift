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
private let elementName = "textinput"

class RSSTextInputTests: QuickSpec {

    override func spec() {

        describe("Deserialization") {

            context("WithFullItem") {

                let xmlIndexer = config.parse(fullTestXML)[elementName]
                it("Succeeds") {
                    expect { try xmlIndexer.value() as RSSTextInput }.toNot(throwError())
                }
                it("IsCorrect") {
                    expect(try? xmlIndexer.value() as RSSTextInput) == fullItem
                }
            }

            context("WithMissing") {

                describe("Title") {
                    let xmlIndexer = config.parse(missingTitleTestXML)[elementName]
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
                describe("Name") {
                    let xmlIndexer = config.parse(missingNameTestXML)[elementName]
                    it("Fails") {
                        expect { try xmlIndexer.value() as RSSTextInput }.to(throwError())
                    }
                }
                describe("Link") {
                    let xmlIndexer = config.parse(missingLinkTestXML)[elementName]
                    it("Fails") {
                        expect { try xmlIndexer.value() as RSSTextInput }.to(throwError())
                    }
                }
            }

            context("WithEmptyXML") {
                let xmlIndexer = config.parse(missingItemsXML)[elementName]

                it("Fails") {
                    expect { try xmlIndexer.value() as RSSTextInput }.to(throwError())
                }
            }

            context("WithNoInput") {
                it("Fails") {
                    let xmlIndexer = config.parse("")[elementName]
                    expect { try xmlIndexer.value() as RSSTextInput }.to(throwError())
                }
            }
        }
    }
}

private let fullItem = RSSTextInput(title: "Search",
                                    description: "Search Google",
                                    name: "q",
                                    link: URL(string: "http://www.google.com/search?")!)

private let fullTestXML = """
    <textinput>
        <title>Search</title>
        <description>Search Google</description>
        <name>q</name>
        <link>http://www.google.com/search?</link>
    </textinput>
    """

private let missingTitleTestXML = """
    <textinput>
        <description>Search Google</description>
        <name>q</name>
        <link>http://www.google.com/search?</link>
    </textinput>
    """

private let missingDescriptionTestXML = """
    <textinput>
        <title>Search</title>
        <name>q</name>
        <link>http://www.google.com/search?</link>
    </textinput>
    """

private let missingNameTestXML = """
    <textinput>
        <title>Search</title>
        <description>Search Google</description>
        <link>http://www.google.com/search?</link>
    </textinput>
    """

private let missingLinkTestXML = """
    <textinput>
        <title>Search</title>
        <description>Search Google</description>
        <name>q</name>
    </textinput>
    """

private let missingItemsXML = """
    <textinput>
    </textinput>
    """
