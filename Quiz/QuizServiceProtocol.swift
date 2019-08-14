//  
//  QuizServiceProtocol.swift
//  Quiz
//
//  Created by Felipe Fleming on 12/08/19.
//  Copyright © 2019 Fleming. All rights reserved.
//

import Foundation

protocol QuizServiceProtocol {
    func getQuiz(completion: @escaping(_ data: QuizModel?) -> Void)
}
