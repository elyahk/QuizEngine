//
//  File.swift
//  QuizEngine
//
//  Created by Eldorbek on 07/05/22.
//

import Foundation

protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer

    typealias AnswerCallback = (Answer) -> Void
    func routeTo(question: Question, answerCallback: @escaping AnswerCallback)
    func routeTo(result: Result<Question, Answer>)
}

public struct Result<Question: Hashable, Answer> {
    let answers: [Question: Answer]
}

class Flow <Question, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
    private let questions: [Question]
    private let router: R
    private lazy var answers: [Question: Answer] = [:]

    init(questions: [Question], router: R) {
        self.questions = questions
        self.router = router
    }

    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallback: routeNext(from: firstQuestion))
        } else {
            router.routeTo(result: Result(answers: [:]))
        }
    }

    private func routeNext(from question: Question) -> R.AnswerCallback {
        return { [weak self] in self?.routeNext(question, answer: $0)
        }
    }

    private func routeNext(_ question: Question, answer: Answer) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            answers[question] = answer
            let nextQuestionIndex = currentQuestionIndex+1

            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                router.routeTo(question: nextQuestion, answerCallback: routeNext(from: nextQuestion))
            } else {
                router.routeTo(result: Result(answers: answers))
            }
        }
    }
}
