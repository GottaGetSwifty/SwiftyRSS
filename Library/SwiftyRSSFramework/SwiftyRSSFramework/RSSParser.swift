//
//  RSSParser.swift
//  BrainsOn
//
//  Created by Paul Fechner on 3/7/19.
//  Copyright © 2019 PeeJWeeJ. All rights reserved.
//

import Foundation
import SWXMLHash

struct RSSFeed<ChannelType: XMLIndexerDeserializable, ItemType: XMLIndexerDeserializable> {
    let channel: ChannelType
    let items: [ItemType]
}

class RSSParser<ChannelType: XMLIndexerDeserializable, ItemType: XMLIndexerDeserializable> {

    enum Keys: String {
        case rss
        case channel
        case item
    }

    private init() {}

    //Runs in background thread and calls completion on the main thread
    class func parse(data: Data, completion: @escaping ([RSSFeed<ChannelType, ItemType>]) -> ()) {
        parse(data: data, completionQueue: DispatchQueue.main, completion: completion)
    }

    //Runs in background thread and calls completion on the passed Queue
    class func parse(data: Data, completionQueue: DispatchQueue,
                     completion: @escaping ([RSSFeed<ChannelType, ItemType>]) -> ()) {
        DispatchQueue.global().async {
            let indexer = SWXMLHash.config { (_) in }.parse(data)
            let channels = makeChannels(indexer)
            completionQueue.async {
                completion(channels)
            }
        }
    }

    //Runs in background thread and calls completion on the passed Queue
    class func parseSynchronously(data: Data) -> [RSSFeed<ChannelType, ItemType>] {

        let indexer = SWXMLHash.config { (_) in }.parse(data)
        let channels = makeChannels(indexer)
        return channels
    }

    class func makeChannels(_ node: XMLIndexer) -> [RSSFeed<ChannelType, ItemType>] {
        let channels = node[Keys.rss][Keys.channel].all.compactMap(parseChannel)
        return channels
    }

    private class func parseChannel(_ channelNode: XMLIndexer) -> RSSFeed<ChannelType, ItemType>? {
        do {
            let channel: ChannelType = try channelNode.value()

            //Manually mapping here because we don't want to whole parse to fail if one item is broken.
            let items: [ItemType] = channelNode[Keys.item].all.compactMap {
                do {
                    let item: ItemType = try $0.value()
                    return item
                } catch let error {
                    print(error.localizedDescription)
                    return nil
                }
            }

            let rssChannel = RSSFeed<ChannelType, ItemType>(channel: channel, items: items)
            return rssChannel
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}
