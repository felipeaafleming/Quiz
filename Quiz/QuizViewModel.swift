//  
//  QuizViewModel.swift
//  Quiz
//
//  Created by Felipe Fleming on 12/08/19.
//  Copyright © 2019 Fleming. All rights reserved.
//

import Foundation

class QuizViewModel {
    
    private let service: QuizServiceProtocol
    private var model: QuizModel?
    private var countdown = 0 {
        didSet {
            didUpdateCountdown?()
        }
    }
    private var timer: Timer?
    var keywords = [String]()
    var isResponding: Bool = false {
        didSet {
            didStartStopResponding?()
        }
    }
    var isLoading: Bool = true
    
    var isTimeout: Bool = false
    
    var question: String {
        if let model = model {
            return model.question
        } else {
            return ""
        }
    }
    
    var hitsString: String {
        if let model = model {
            return "\(keywords.count)/\(model.answer.count)"
        } else {
            return "0/0"
        }
    }
    
    var buttonString: String {
        if isResponding {
            return "Reset"
        } else {
            return "Start"
        }
    }

    var countdownString: String {
        let minutes = countdown/60
        let seconds = countdown%60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    var alertTitle: String {
        if isTimeout {
            return "Time finished"
        } else {
            return "Congratulations"
        }
    }
    
    var alertMessage: String {
        if isTimeout {
            return "Sorry, time is up! You got \(keywords.count) out of \(model?.answer.count ?? 0) answers"
        } else {
            return "Good job! You found all the answers on time. Keep up with the great work"
        }
    }
    
    var alertButtonText: String {
        if isTimeout {
            return "Try Again"
        } else {
            return "Play Again"
        }
    }
    
    var didStartGettingData: (() -> Void)?
    var didGetData: (() -> Void)?
    var shouldUpdateForHitOrReset: (() -> Void)?
    var didUpdateCountdown: (() -> Void)?
    var raizeAlert: (() -> Void)?
    var didStartStopResponding: (() -> Void)?
    
    init(withQuiz serviceProtocol: QuizServiceProtocol = QuizService()) {
        self.service = serviceProtocol
    }
}

extension QuizViewModel {
    func startQuiz() {
        isLoading = true
        didStartGettingData?()
        DispatchQueue.global(qos: .background).async {
            self.service.getQuiz { (quizModel) in
                DispatchQueue.main.async {
                    self.model = quizModel
                    self.isLoading = false
                    self.didGetData?()
                }
            }
        }
    }
    
    func checkHit(word: String) -> Bool {
        guard let model = model else {
            return true
        }
        if !keywords.contains(word) && model.answer.contains(word) {
            keywords.insert(word, at: 0)
            shouldUpdateForHitOrReset?()
            if keywords.count == model.answer.count {
                timer?.invalidate()
                isResponding = false
                raizeAlert?()
            }
            return true
        }
        return false
    }
    
    func resetQuiz() {
        countdown = 0
        timer?.invalidate()
        isResponding = false
        keywords = [String]()
        shouldUpdateForHitOrReset?()
    }
    
    func startQuizBind() {
        keywords = [String]()
        shouldUpdateForHitOrReset?()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        isResponding = true
        isTimeout = false
        countdown = 5 * 60
    }
    
    @objc private func updateTimer() {
        if countdown == 0 {
            isTimeout = true
            timer?.invalidate()
            isResponding = false
            raizeAlert?()
        } else {
            countdown -= 1
        }
    }
}
