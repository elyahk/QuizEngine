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
    private let questions: [String]
    private let router: Router
    private lazy var result: [String:String] = [:]

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

    private func routeNext(from question: String) -> (String) -> Void {
        return { [weak self] in self?.routeNext(question, answer: $0)
        }
    }

    private func routeNext(_ question: String, answer: String) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            result[question] = answer
            let nextQuestionIndex = currentQuestionIndex+1

            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                router.routeTo(question: nextQuestion, answerCallback: routeNext(from: nextQuestion))
            } else {
                router.routeTo(result: result)
            }
        }
    }
}
