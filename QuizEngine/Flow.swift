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
        delegateQuestionHandling(at: questions.startIndex)
    }

    private func delegateQuestionHandling(at index: Int) {
        if index < questions.endIndex {
            let question = questions[index]
            delegate.handle(question: question, answerCallback: callback(for: question, at: index))
        } else {
            delegate.handle(result: result())
        }
    }

    private func delegateQuestionHandling(after index: Int) {
        delegateQuestionHandling(at: questions.index(after: index))
    }

    private func callback(for question: Question, at index: Int) -> Delegate.AnswerCallback {
        return { [weak self] answer in
            self?.answers[question] = answer
            self?.delegateQuestionHandling(after: index)
        }
    }

    private func result() -> Result<Question, Answer> {
        Result(answers: answers, score: scoring(answers))
    }
}
