//
//  Quiz.swift
//  QuizEngine
//
//  Created by Eldorbek on 25/05/22.
//

import Foundation

public final class Quiz {
    private let flow: Any

    init(flow: Any) {
        self.flow = flow
    }

    public static func start<Question, Answer: Equatable, Delegate: QuizDelegate>(questions: [Question], delegate: Delegate, answers: [Question: Answer]) -> Quiz where Delegate.Question == Question, Delegate.Answer == Answer {
        let flow = Flow(questions: questions, delegate: delegate, scoring: { scoring($0, correctAnswers: answers) })
        flow.start()

        return Quiz(flow: flow)
    }
}

