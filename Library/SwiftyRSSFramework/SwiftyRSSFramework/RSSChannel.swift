//
//  RSS.swift
//  SwiftyRSSFramework
//
//  XMLDeserializable Type based on RSS Spec: https://cyber.harvard.edu/rss/rss.html
//
//  Created by Paul Fechner on 4/2/19.
//  Copyright © 2019 PeeJWeeJ. All rights reserved.
//
import SWXMLHash

//swiftlint:disable line_length

/// Specifies the hours where aggregators should skip updating the feed.
/// Better documentation [here](https://www.w3schools.com/XML/rss_tag_skipHours.asp)
/// - There can be up to 24 <hour> elements within the <skipHours> element
/// - 0 represents midnight.
public struct RSSSkipHours: Equatable, Codable, XMLIndexerDeserializable {
    var hour: [Int]

    public static func deserialize(_ element: XMLIndexer) throws -> RSSSkipHours {

        let hours: [Int] = element[CodingKeys.hour.stringValue].all.compactMap { try? $0.value() }
        let invalidHour = hours.first(where: {!(0...23).contains($0)})
        // 0-23 is only valid input. Fail if wrong
        guard invalidHour == nil else {
            print("RSSSkipHours attemped to be initialized hour <0 || >23: \(String(describing: invalidHour)) invalid in \(hours)")
            throw XMLDeserializationError.nodeIsInvalid(node: element)
        }
        return RSSSkipHours(hour: element[CodingKeys.hour.stringValue].all.compactMap { try? $0.value() })
    }
}

//swiftlint:disable identifier_name
///Possible values of RSS [skipDays](https://cyber.harvard.edu/rss/skipHoursDays.html#skiphours). Example [here](https://www.w3schools.com/XML/rss_tag_skipDays.asp)
public enum RSSSkipDay: String, Codable, CaseIterable {
    case Sunday
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
}
//swiftlint:enable identifier_name

/// An XML element that contains up to seven <day> sub-elements whose value is Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday. Aggregators may not read the channel during days listed in the skipDays element.
public struct RSSSkipDays: Codable, XMLIndexerDeserializable {

    var day: [RSSSkipDay]

    public static func deserialize(_ element: XMLIndexer) throws -> RSSSkipDays {
        return RSSSkipDays(day: element[CodingKeys.day.stringValue].all.compactMap {
            guard  let skipDay = try? RSSSkipDay(rawValue: $0.value()) else {
                print("Invalid skip day: \($0.description)")
                return nil
            }
            return skipDay
        })
    }
}

/// An optional sub-element of <channel>, which contains three required and three optional sub-elements.
public struct RSSImage: Codable, XMLElementDeserializable {

    // Required Elements

    /// The URL of a GIF, JPEG or PNG image that represents the channel.
    let url: URL
    /// Describes the image, it's used in the ALT attribute of the HTML <img> tag when the channel is rendered in HTML.
    let title: String

    ///  The URL of the site, when the channel is rendered, the image is a link to the site. (Note, in practice the image <title> and <link> should have the same value as the channel's <title> and <link>.

    let link: URL

    // Optional Elements

    /// indicating the width of the image in pixels
    /// - Maximum value for width is 144, default value is 88.
    let width: Double?
    /// indicating the height of the image in pixels
    /// - Maximum value for height is 400, default value is 31.
    let height: Double?
    /// contains text that is included in the TITLE attribute of the link formed around the image in the HTML rendering.
    let description: String?

    public static func deserialize(_ element: XMLElement) throws -> RSSImage {
        return RSSImage(url: try element.value(ofAttribute: CodingKeys.url),
                        title: try element.value(ofAttribute: CodingKeys.title),
                        link: try element.value(ofAttribute: CodingKeys.link),
                        width: element.value(ofAttribute: CodingKeys.width),
                        height: element.value(ofAttribute: CodingKeys.height),
                        description: element.value(ofAttribute: CodingKeys.description))
    }
}

/// It has one optional attribute, domain,
/// - Example: `<category>Grateful Dead</category>`, `<category domain="http://www.fool.com/cusips">MSFT</category>`
public struct RSSCategory: Codable, XMLElementDeserializable {

    // Required Elements

    /// A forward-slash-separated string that identifies a hierarchic location in the indicated taxonomy. Processors may establish conventions for the interpretation of categories. Two examples are provided below:
    let value: String

    // Optional Elements

    /// A string that identifies a categorization taxonomy.
    let domain: URL?

    public static func deserialize(_ element: XMLElement) throws -> RSSCategory {

        var domain: URL?
        if let domainText = element.attribute(by: CodingKeys.domain.stringValue)?.text {
            domain = URL(string: domainText)
        }

        return RSSCategory(value: try element.value(ofAttribute: CodingKeys.value),
                           domain: domain)
    }
}

/// A channel may optionally contain a <textInput> sub-element, which contains four required sub-elements.
/// - The purpose of the <textInput> element is something of a mystery. You can use it to specify a search engine box. Or to allow a reader to provide feedback. Most aggregators ignore it.
public struct RSSTextInput: Codable, XMLElementDeserializable {
    /// The label of the Submit button in the text input area.
    let title: String
    /// Explains the text input area.
    let description: String
    /// The name of the text object in the text input area.
    let name: String
    /// The URL of the CGI script that processes text input requests.
    let link: URL

    public static func deserialize(_ element: XMLElement) throws -> RSSTextInput {
        return RSSTextInput(title: try element.value(ofAttribute: CodingKeys.title),
                            description: try element.value(ofAttribute: CodingKeys.description),
                            name: try element.value(ofAttribute: CodingKeys.name),
                            link: try element.value(ofAttribute: CodingKeys.link))
    }
}

public struct RSSChannel: Codable, XMLIndexerDeserializable {

    // Required Elements

    /// The name of the channel. It's how people refer to your service. If you have an HTML website that contains the same information as your RSS file, the title of your channel should be the same as the title of your website.
    let title: String
    /// The URL to the HTML website corresponding to the channel.
    let link: URL
    /// Phrase or sentence describing the channel.
    let description: String

    // Optional Elements

    ///The language the channel is written in. This allows aggregators to group all Italian language sites, for example, on a single page. A list of allowable values for this element, as provided by Netscape, is [here](https://cyber.harvard.edu/rss/languages.html). You may also use [values defined](http://www.w3.org/TR/REC-html40/struct/dirlang.html#langcodes) by the W3C.
    /// - Example: en-us
    let language: String?
    ///Copyright notice for content in the channel.
    let copyright: String?
    ///Email address for person responsible for editorial content.
    let managingEditor: String?
    ///Email address for person responsible for technical issues relating to channel.
    let webMaster: String?
    /// The publication date for the content in the channel. For example, the New York Times publishes on a daily basis, the publication date flips once every 24 hours. That's when the pubDate of the channel changes. All date-times in RSS conform to the Date and Time Specification of [RFC 822](https://www.w3.org/Protocols/rfc822/), with the exception that the year may be expressed with two characters or four characters (four preferred).
    /// - Example: Sat, 07 Sep 2002 00:00:01 GMT
    let pubDate: Date?
    /// The last time the content of the channel changed.
    /// - Example: Sat, 07 Sep 2002 00:00:01 GMT
    let lastBuildDate: Date?
    ///Specify one or more categories that the channel belongs to. Follows the same rules as the <item>-level [category](https://cyber.harvard.edu/rss/rss.html#ltcategorygtSubelementOfLtitemgt) element. More [info](https://cyber.harvard.edu/rss/rss.html#syndic8).
    /// - Example: `<category>Newspapers</category>`, <category domain="http://www.fool.com/cusips">MSFT</category>
    let category: [RSSCategory]
    /// A string indicating the program used to generate the channel.
    let generator: String?
    /// A URL that points to the documentation for the format used in the RSS file. It's probably a pointer to this page. It's for people who might stumble across an RSS file on a Web server 25 years from now and wonder what it is.
    /// - Example: http://blogs.law.harvard.edu/tech/rss
    let docs: URL?
    /// Allows processes to register with a cloud to be notified of updates to the channel, implementing a lightweight publish-subscribe protocol for RSS feeds. More info [here](https://cyber.harvard.edu/rss/rss.html#ltcloudgtSubelementOfLtchannelgt).
    let cloud: Int?
    /// ttl stands for time to live. It's a number of minutes that indicates how long a channel can be cached before refreshing from the source. More info [here](https://cyber.harvard.edu/rss/rss.html#ltttlgtSubelementOfLtchannelgt).
    let ttl: Double?
    /// Specifies a GIF, JPEG or PNG image that can be displayed with the channel. More info [here](https://cyber.harvard.edu/rss/rss.html#ltimagegtSubelementOfLtchannelgt).
    let image: RSSImage?
    /// The [PICS](http://www.w3.org/PICS/) rating for the channel
    let rating: String?
    /// Specifies a text input box that can be displayed with the channel. More info [here](https://cyber.harvard.edu/rss/rss.html#lttextinputgtSubelementOfLtchannelgt).
    let textInput: RSSTextInput?
    /// A hint for aggregators telling them which hours they can skip. More info [here](https://cyber.harvard.edu/rss/skipHoursDays.html#skiphours).
    let skipHours: RSSSkipHours?
    /// A hint for aggregators telling them which days they can skip. More info [here](https://cyber.harvard.edu/rss/skipHoursDays.html#skipdays).
    let skipDays: RSSSkipDays?

    public static func deserialize(_ element: XMLIndexer) throws -> RSSChannel {

        return RSSChannel(title: try element[CodingKeys.title.stringValue].value(),
                          link: try element[CodingKeys.link.stringValue].value(),
                          description: try element[CodingKeys.description.stringValue].value(),
                          language: try? element[CodingKeys.language.stringValue].value(),
                          copyright: try? element[CodingKeys.copyright.stringValue].value(),
                          managingEditor: try? element[CodingKeys.managingEditor.stringValue].value(),
                          webMaster: try? element[CodingKeys.webMaster.stringValue].value(),
                          pubDate: try? element[CodingKeys.pubDate.stringValue].value(),
                          lastBuildDate: try? element[CodingKeys.lastBuildDate.stringValue].value(),
                          category: element[CodingKeys.category.stringValue].all.compactMap { try? $0.value() },
                          generator: try? element[CodingKeys.generator.stringValue].value(),
                          docs: try? element[CodingKeys.docs.stringValue].value(),
                          cloud: try? element[CodingKeys.cloud.stringValue].value(),
                          ttl: try? element[CodingKeys.ttl.stringValue].value(),
                          image: try? element[CodingKeys.image.stringValue].value(),
                          rating: try? element[CodingKeys.rating.stringValue].value(),
                          textInput: try? element[CodingKeys.textInput.stringValue].value(),
                          skipHours: try? element[CodingKeys.skipHours.stringValue].value(),
                          skipDays: try? element[CodingKeys.skipDays.stringValue].value())
    }
}

/// URL XML deserialization for URLs
extension URL: XMLElementDeserializable, XMLAttributeDeserializable {

    public static func deserialize(_ element: XMLElement) throws -> URL {
        guard let url = URL(string: element.text) else {
            throw XMLDeserializationError.typeConversionFailed(type: "URL", element: element)
        }
        return url
    }

    public static func deserialize(_ attribute: XMLAttribute) throws -> URL {
        guard let url = URL(string: attribute.text) else {
            throw XMLDeserializationError.attributeDeserializationFailed(type: "URL", attribute: attribute)
        }
        return url
    }
}

private let standardDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
    return formatter
}()

/// Date XML deserialization using the standardDateFormatter (using [RFC822](https://www.w3.org/Protocols/rfc822/)
extension Date: XMLElementDeserializable, XMLAttributeDeserializable {

    public static func deserialize(_ element: XMLElement) throws -> Date {
        guard let date = standardDateFormatter.date(from: element.text) else {
            throw XMLDeserializationError.typeConversionFailed(type: "Date", element: element)
        }
        return date
    }

    public static func deserialize(_ attribute: XMLAttribute) throws -> Date {
        guard let date = standardDateFormatter.date(from: attribute.text) else {
            throw XMLDeserializationError.attributeDeserializationFailed(type: "Date", attribute: attribute)
        }
        return date
    }
}

/// Allows interaction using CodingKeys
fileprivate extension XMLElement {

    func value<T: XMLAttributeDeserializable, A: CodingKey>(ofAttribute attr: A) throws -> T {
        return try value(ofAttribute: attr.stringValue)
    }

    func value<T: XMLAttributeDeserializable, A: CodingKey>(ofAttribute attr: A) -> T? {
        return value(ofAttribute: attr.stringValue)
    }
}

//swiftlint:enable line_length
