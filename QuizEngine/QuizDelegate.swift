//
//  QuizDelegate.swift
//  QuizEngine
//
//  Created by Eldorbek on 25/05/22.
//

import Foundation

public protocol QuizDelegate {
    associatedtype Question: Hashable
    associatedtype Answer
    typealias AnswerComletion = (Answer) -> Void

    func answer(for question: Question, completion: @escaping AnswerComletion)

    func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)])

    @available(*, deprecated, message: "Use didCompleteQuiz(withAnswers:) API instead")
    func handle(result: Result<Question, Answer>)
}

public extension QuizDelegate {
    func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)]) { }
}
