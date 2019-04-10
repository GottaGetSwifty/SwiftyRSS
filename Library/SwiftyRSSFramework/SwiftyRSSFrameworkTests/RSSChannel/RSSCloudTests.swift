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
private let elementName = "cloud"

//swiftlint:disable line_length
class RSSCloudTests: QuickSpec {

    override func spec() {
        describe("Deserialization") {

            context("WithFullItem") {

                let xmlIndexer = config.parse(fullTestXML)[elementName]
                it("Succeeds") {
                    expect { try xmlIndexer.value() as RSSCloud }.toNot(throwError())
                }
                it("IsCorrect") {
                    expect(try? xmlIndexer.value() as RSSCloud) == fullItem
                }
            }
            context("WithMissing") {

                describe("domain") {
                    let xmlIndexer = config.parse(missingDomainTestXML)[elementName]
                    it("Fails") {
                        expect { try xmlIndexer.value() as RSSCloud }.to(throwError())
                    }
                }
                describe("port") {
                    let xmlIndexer = config.parse(missingPortTestXML)[elementName]
                    it("Fails") {
                        expect { try xmlIndexer.value() as RSSCloud }.to(throwError())
                    }
                }
                describe("path") {
                    let xmlIndexer = config.parse(missingPathTestXML)[elementName]
                    it("Fails") {
                        expect { try xmlIndexer.value() as RSSCloud }.to(throwError())
                    }
                }
                describe("registerProcedure") {
                    let xmlIndexer = config.parse(missingRegisterProcedureTestXML)[elementName]
                    it("Fails") {
                        expect { try xmlIndexer.value() as RSSCloud }.to(throwError())
                    }
                }
                describe("protocol") {
                    let xmlIndexer = config.parse(missingProtocolTestXML)[elementName]
                    it("Fails") {
                        expect { try xmlIndexer.value() as RSSCloud }.to(throwError())
                    }
                }
            }
            context("NoInput") {
                it("Fails") {
                    let xmlIndexer = config.parse("")[elementName]
                    expect { try xmlIndexer.value() as RSSCloud }.to(throwError())
                }
            }
        }
    }
}

private let fullItem = RSSCloud(domain: "radio.xmlstoragesystem.com", port: "80", path: "/RPC2", registerProcedure: "xmlStorageSystem.rssPleaseNotify", protocol: "xml-rpc")

private let fullTestXML = """
    <cloud domain="radio.xmlstoragesystem.com" port="80" path="/RPC2" registerProcedure="xmlStorageSystem.rssPleaseNotify" protocol="xml-rpc" />
    """

private let missingDomainTestXML = """
<cloud port="80" path="/RPC2" registerProcedure="xmlStorageSystem.rssPleaseNotify" protocol="xml-rpc" />
"""

private let missingPortTestXML = """
<cloud domain="radio.xmlstoragesystem.com" path="/RPC2" registerProcedure="xmlStorageSystem.rssPleaseNotify" protocol="xml-rpc" />
"""

private let missingPathTestXML = """
<cloud domain="radio.xmlstoragesystem.com" port="80" registerProcedure="xmlStorageSystem.rssPleaseNotify" protocol="xml-rpc" />
"""

private let missingRegisterProcedureTestXML = """
<cloud domain="radio.xmlstoragesystem.com" port="80" path="/RPC2" protocol="xml-rpc" />
"""

private let missingProtocolTestXML = """
<cloud domain="radio.xmlstoragesystem.com" port="80" path="/RPC2" registerProcedure="xmlStorageSystem.rssPleaseNotify" />
"""
//swiftlint:enable line_length
