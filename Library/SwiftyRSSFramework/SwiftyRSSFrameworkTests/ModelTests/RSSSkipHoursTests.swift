//
//  RSSSkipHoursTests.swift
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
private let elementName = "skipHours"

class RSSSkipHoursTests: QuickSpec {

    override func spec() {

        describe("Initialization") {

            context("WithValidInput") {
                it("Succeeds") {
                    expect { try RSSSkipHours(hour: Array(0...23)) }.toNot(throwError())
                    expect { try RSSSkipHours(hour: []) }.toNot(throwError())
                    expect { try RSSSkipHours(hour: []) }.toNot(throwError())
                }
                it("Matches") {
                    expect(try? RSSSkipHours(hour: Array(0...23)).hour) == Array(0...23)
                    expect(try? RSSSkipHours(hour: [1]).hour) == [1]
                    expect(try? RSSSkipHours(hour: []).hour) == []
                }
            }

            context("WithInvalidInput") {
                it("Fails") {
                    expect { try RSSSkipHours(hour: Array(0...24)) }.to(throwError())
                    expect { try RSSSkipHours(hour: Array(-5...5)) }.to(throwError())
                }
            }
        }
        
        describe("Deserialization") {

            context("WithFullItem") {

                let xmlIndexer = config.parse(fullTestXML)[elementName]
                it("Succeeds") {
                    expect { try xmlIndexer.value() as RSSSkipHours }.toNot(throwError())
                }
                it("IsCorrect") {
                    expect((try? xmlIndexer.value() as RSSSkipHours)?.hour) == Array(0...23)
                }
            }
            context("WithEmptyItem") {

                let xmlIndexer = config.parse(emptyTestXML)[elementName]
                it("Succeeds") {
                    expect { try xmlIndexer.value() as RSSSkipHours }.toNot(throwError())
                }
                it("IsCorrect") {
                    expect((try? xmlIndexer.value() as RSSSkipHours)?.hour) == []
                }
            }
            context("WithNoInput") {
                it("Fails") {
                    expect {try config.parse("")[elementName].value() as RSSSkipHours }.to(throwError())
                }
            }
        }
    }
}

// Putting these outside of the class so it's not necessary to use `self`
private let fullTestXML = """
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

private let extraTestXML = """
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

private let emptyTestXML = """
    <skipHours>
    </skipHours>
    """
