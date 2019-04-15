//
//  RSSParser.swift
//  BrainsOn
//
//  Created by Paul Fechner on 3/7/19.
//  Copyright © 2019 PeeJWeeJ. All rights reserved.
//

import Foundation
import SWXMLHash

typealias StandardRSSFeed = RSSFeed<RSSChannel, RSSItem>
typealias StandardRSSParser = RSSParser<RSSChannel, RSSItem>

typealias RSSAble = XMLIndexerDeserializable & Codable & Equatable

struct RSSFeed<ChannelType: RSSAble, ItemType: RSSAble>: RSSAble {

    let channel: ChannelType
    let item: [ItemType]

    static func deserialize(_ element: XMLIndexer) throws -> RSSFeed<ChannelType, ItemType> {
        return RSSFeed(channel: try element[CodingKeys.channel].value(),
                       item: element[CodingKeys.channel][CodingKeys.item].all.compactMap { try? $0.value() })
    }
}

class RSSParser<ChannelType: RSSAble, ItemType: RSSAble> {
    typealias RSSFeedType = RSSFeed<ChannelType, ItemType>
    private init() {}

    //Runs in background thread and calls completion on the main thread
    class func parse(data: Data, completion: @escaping (Result<RSSFeedType, Error>) -> ()) {
        parse(data: data, completionQueue: DispatchQueue.main, completion: completion)
    }

    //Runs in background thread and calls completion on the passed Queue
    class func parse(data: Data, completionQueue: DispatchQueue,
                     completion: @escaping (Result<RSSFeedType, Error>) -> ()) {

        DispatchQueue.global().async {
            let result = parseSynchronously(data: data)
            completionQueue.async { completion(result) }
        }
    }

    //Runs in background thread and calls completion on the passed Queue
    class func parseSynchronously(data: Data) -> Result<RSSFeedType, Error> {

        let indexer = SWXMLHash.config { (_) in }.parse(data)
        do {
            let channels = try makeChannel(indexer)
            return Result.success(channels)
        }
        catch let error {
            return Result.failure(error)
        }
    }

    class func makeChannel(_ node: XMLIndexer) throws -> RSSFeedType {
        let channel = try RSSFeed<ChannelType, ItemType>.deserialize(node)
        return channel
    }
}
