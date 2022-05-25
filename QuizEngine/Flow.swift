//
//  File.swift
//  QuizEngine
//
//  Created by Eldorbek on 07/05/22.
//

import Foundation

class Flow <Delegate: QuizDelegate> {
    typealias Question = Delegate.Question
    typealias Answer = Delegate.Answer

    private let questions: [Question]
    private let delegate: Delegate
    private let scoring: (([Question: Answer]) -> Int)
    private lazy var answers: [Question: Answer] = [:]

    init(questions: [Question], router: Delegate, scoring: @escaping ([Question: Answer]) -> Int) {
        self.questions = questions
        self.delegate = router
        self.scoring = scoring
    }

    func start() {
        routeToQuestion(at: questions.startIndex)
    }

    private func routeToQuestion(at index: Int) {
        if index < questions.endIndex {
            let question = questions[index]
            delegate.handle(question: question, answerCallback: routeNext(from: question))
        } else {
            delegate.handle(result: result())
        }
    }

    private func routeNext(from question: Question) -> Delegate.AnswerCallback {
        return { [weak self] in self?.routeNext(question, answer: $0)
        }
    }

    private func routeNext(_ question: Question, answer: Answer) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            answers[question] = answer
            let nextQuestionIndex = currentQuestionIndex+1

            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                delegate.handle(question: nextQuestion, answerCallback: routeNext(from: nextQuestion))
            } else {
                delegate.handle(result: result())
            }
        }
    }

    private func result() -> Result<Question, Answer> {
        Result(answers: answers, score: scoring(answers))
    }
}
