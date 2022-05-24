//
//  File.swift
//  QuizEngine
//
//  Created by Eldorbek on 07/05/22.
//

import Foundation

class Flow <R: QuizDelegate> {
    typealias Question = R.Question
    typealias Answer = R.Answer

    private let questions: [Question]
    private let router: R
    private let scoring: (([Question: Answer]) -> Int)
    private lazy var answers: [Question: Answer] = [:]

    init(questions: [Question], router: R, scoring: @escaping ([Question: Answer]) -> Int) {
        self.questions = questions
        self.router = router
        self.scoring = scoring
    }

    func start() {
        if let firstQuestion = questions.first {
            router.handle(question: firstQuestion, answerCallback: routeNext(from: firstQuestion))
        } else {
            router.handle(result: result())
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
                router.handle(question: nextQuestion, answerCallback: routeNext(from: nextQuestion))
            } else {
                router.handle(result: result())
            }
        }
    }

    private func result() -> Result<Question, Answer> {
        Result(answers: answers, score: scoring(answers))
    }
}
