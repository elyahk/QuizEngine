//
//  File.swift
//  QuizEngine
//
//  Created by Eldorbek on 07/05/22.
//

import Foundation

protocol Router {
    typealias AnswerCallback = (String) -> Void
    func routeTo(question: String, answerCallback: @escaping AnswerCallback)
    func routeTo(result: [String:String])
}

class Flow {
    let questions: [String]
    let router: Router

    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }

    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallback: routeNext(from: firstQuestion))
        } else {
            router.routeTo(result: [:])
        }
    }

    func routeNext(from question: String) -> (String) -> Void {
        return { [weak self] _ in
            guard let self = self else { return }

            if let currentQuestionIndex = self.questions.firstIndex(of: question) {
                if currentQuestionIndex < self.questions.count - 1 {
                    let nextQuestion = self.questions[currentQuestionIndex+1]
                    self.router.routeTo(question: nextQuestion, answerCallback: self.routeNext(from: nextQuestion))
                }
            }
        }
    }
}
