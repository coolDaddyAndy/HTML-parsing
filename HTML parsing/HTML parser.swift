//
//  HTML parser.swift
//  HTML parsing
//
//  Created by Andrei Sushkou on 20.02.23.
//

import SwiftSoup
import Foundation

final class HTMLParser {
    
    func parse(html: String) {
        do {
            let document: Document = try SwiftSoup.parse(html)
            guard let body = document.body() else {
                return
            }
            let headers: [String] = try body.getElementsByTag("h3").compactMap({
               try? $0.html()
            })
            print (headers)
        }
        catch {
            print ("Error parsing:  " + String(describing: error))
        }
    }
}
