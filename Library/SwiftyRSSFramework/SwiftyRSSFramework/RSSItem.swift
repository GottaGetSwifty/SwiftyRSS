//
//  RSSItem.swift
//  SwiftyRSSFramework
//
//  Created by Paul Fechner on 4/10/19.
//  Copyright © 2019 PeeJWeeJ. All rights reserved.
//
//  Spec and documentation taken from:
// [here](https://cyber.harvard.edu/rss/rss.html#hrelementsOfLtitemgt)
//

import Foundation
import SWXMLHash

//swiftlint:disable line_length

///A channel may contain any number of <item>s. An item may represent a "story" -- much like a story in a newspaper or magazine; if so its description is a synopsis of the story, and the link points to the full story. An item may also be complete in itself, if so, the description contains the text (entity-encoded HTML is allowed; see [examples](https://cyber.harvard.edu/rss/encodingDescriptions.html)), and the link and title may be omitted. All elements of an item are optional, however at least one of title or description must be present.
public struct RSSItem: Codable, Equatable, XMLIndexerDeserializable {

    /// The title of the item.
    /// - Example: Venice Film Festival Tries to Quit Sinking
    let title: String?
    /// The URL of the item.
    /// - Example: http://nytimes.com/2004/12/07FEST.html
    let link: URL?
    /// The item synopsis.
    /// - Example: Some of the most heated chatter at the Venice Film Festival this week was about the way that the arrival of the stars at the Palazzo del Cinema was being staged.
    let description: String?
    /// Email address of the author of the item. [More](https://cyber.harvard.edu/rss/rss.html#ltauthorgtSubelementOfLtitemgt).
    /// - Example: oprah\@oxygen.net
    let author: String?
    /// Includes the item in one or more categories. [More](https://cyber.harvard.edu/rss/rss.html#ltcategorygtSubelementOfLtitemgt).
    let category: [RSSCategory]
    /// URL of a page for comments relating to the item. More.
    /// - Example: http://www.myblog.org/cgi-local/mt/mt-comments.cgi?entry_id=290
    let comments: URL?
    /// Describes a media object that is attached to the item. [More](https://cyber.harvard.edu/rss/rss.html#ltenclosuregtSubelementOfLtitemgt).
    let enclosure: RSSEnclosure?
    /// A string that uniquely identifies the item. [More](https://cyber.harvard.edu/rss/rss.html#ltguidgtSubelementOfLtitemgt).
    /// - Example: http://inessential.com/2002/09/01.php#a2
    let guid: String?
    /// Indicates when the item was published. [More](https://cyber.harvard.edu/rss/rss.html#ltpubdategtSubelementOfLtitemgt).
    /// Example: Sun, 19 May 2002 15:21:36 GMT
    let pubDate: Date?
    /// The RSS channel that the item came from. [More](https://cyber.harvard.edu/rss/rss.html#ltsourcegtSubelementOfLtitemgt).
    let source: RSSSource?

    public static func deserialize(_ element: XMLIndexer) throws -> RSSItem {
        return RSSItem(title: try? element[CodingKeys.title].value(),
                       link: try? element[CodingKeys.link].value(),
                       description: try? element[CodingKeys.description].value(),
                       author: try? element[CodingKeys.author].value(),
                       category: (try? element[CodingKeys.category].value()) ?? [],
                       comments: try? element[CodingKeys.comments].value(),
                       enclosure: try? element[CodingKeys.enclosure].value(),
                       guid: try? element[CodingKeys.guid].value(),
                       pubDate: try? element[CodingKeys.pubDate].value(),
                       source: try? element[CodingKeys.source].value())
    }
}

/// <enclosure> is an optional sub-element of <item>.
/// It has three required attributes. url says where the enclosure is located, length says how big it is in bytes, and type says what its type is, a standard MIME type.
/// The url must be an http url.
/// - Example: <enclosure url="http://www.scripting.com/mp3s/weatherReportSuite.mp3" length="12216320" type="audio/mpeg" />
public struct RSSEnclosure: Codable, Equatable, XMLIndexerDeserializable {

    /// Where the enclosure is located
    @XMLAttributeProperty
    var url: URL
    /// How big it is in bytes
    @XMLAttributeProperty
    var length: Float
    /// What its type is, a standard MIME type. Must be an http url.
    @XMLAttributeProperty
    var type: String

    init(url: XMLAttributeProperty<URL>, length: XMLAttributeProperty<Float>, type: XMLAttributeProperty<String>) {
        $url = url
        $length = length
        $type = type
    }

    init(rawURL url: URL, rawLength length: Float, rawType type: String) {
        self.init(url: XMLAttributeProperty(value: url), length: XMLAttributeProperty(value: length), type: XMLAttributeProperty(value: type))
    }

    public static func deserialize(_ element: XMLIndexer) throws -> RSSEnclosure {
        return RSSEnclosure(url: try element.value(of: CodingKeys.url),
                            length: try element.value(of: CodingKeys.length),
                            type: try element.value(of: CodingKeys.type))
    }
}

/// <source> is an optional sub-element of <item>.
/// Its value is the name of the RSS channel that the item came from, derived from its <title>. It has one required attribute, url, which links to the XMLization of the source.
/// - Example: <source url="http://www.tomalak.org/links2.xml">Tomalak's Realm</source>
public struct RSSSource: Codable, Equatable, XMLElementDeserializable {

    let value: String

    @XMLAttributeProperty
    var url: URL

    init(value: String, url: XMLAttributeProperty<URL>) throws {
        guard !value.isEmpty else {
            throw RSSSourceError.missingValue
        }
        $url = url
        self.value = value
    }

    /// Throwing initializer to ensure it's not initialized without a value
    init(value: String, rawURL theURL: URL) throws {
        try self.init(value: value, url: XMLAttributeProperty(value: theURL))
    }

    public static func deserialize(_ element: XMLElement) throws -> RSSSource {
        return try RSSSource(value: element.text,
                             url: element.value(of: CodingKeys.url))
    }
//    init(from decoder: Decoder) {
//
//    }

    enum RSSSourceError: Error, CustomStringConvertible {
        case missingValue

        var description: String {
            switch self {
            case .missingValue: return "Initialized with an empty value"
            }
        }
    }
}

//extension XMLElement {
//    func value<T>(attributeName: String) throws -> XMLAttributeWrapper<T> {
//            return try value(ofAttribute: attribute)
//    }
//}

//typealias XMLThing = Equatable & Codable & XMLAttributeDeserializable
//@propertyWrapper
//struct XMLAttributeWrapper<T: XMLThing>: XMLThing {
//
//    let value: T
//    init(value: T) {
//        self.value = value
//    }
//    var wrappedValue: T {
//        return value
//    }
//
//    static func deserialize(_ attribute: XMLAttribute) throws -> XMLAttributeWrapper<T> {
//        let result = try XMLAttributeWrapper(value: T.deserialize(attribute))
//        print(result)
//        return result
//    }
//}
//
//extension XMLElement {
//    func value<PathEnd>(_ key: String) throws -> XMLAttributeWrapper<PathEnd> {
//        return try value(ofAttribute: key)
//    }
//}

//swiftlint:enable line_length
