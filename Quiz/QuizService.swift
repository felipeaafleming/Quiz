//  
//  QuizService.swift
//  Quiz
//
//  Created by Felipe Fleming on 12/08/19.
//  Copyright © 2019 Fleming. All rights reserved.
//

import Foundation

class QuizService: QuizServiceProtocol {
    private var quizModel: QuizModel?
    
    func getQuiz(completion: @escaping(_ data: QuizModel?) -> Void) {
        if let quizModel = quizModel {
            completion(quizModel)
            return
        }

        let task = URLSession.shared.dataTask(with: API.Endpoints.javaKeywords.url) { (data, _, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            if error != nil {
                completion(nil)
                return
            }
            do {
                self.quizModel = try JSONDecoder().decode(QuizModel.self, from: data)
                completion(self.quizModel)
            } catch _ {
                completion(nil)
            }
        }
        task.resume()
    }
}
