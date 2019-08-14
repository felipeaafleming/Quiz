//
//  API.swift
//  Quiz
//
//  Created by Felipe Fleming on 12/08/19.
//  Copyright © 2019 Fleming. All rights reserved.
//

import Foundation

struct API {
    enum Endpoints {
        case javaKeywords

        var url: URL {
            if self == .javaKeywords {
                return URL(string: "https://codechallenge.arctouch.com/quiz/java-keywords")!
            } else {
                return URL(string: "https://codechallenge.arctouch.com/quiz/java-keywords")!
            }
        }
    }
}
