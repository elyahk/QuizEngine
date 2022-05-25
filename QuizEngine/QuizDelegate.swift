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

    typealias AnswerCallback = (Answer) -> Void
    func handle(question: Question, answerCallback: @escaping AnswerCallback)
    func handle(result: Result<Question, Answer>)
}
