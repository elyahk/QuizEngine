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

    public static func start<Delegate: QuizDelegate>(
        questions: [Delegate.Question],
        delegate: Delegate,
        answers: [Delegate.Question: Delegate.Answer]
    ) -> Quiz where Delegate.Answer: Equatable {
        let flow = Flow(questions: questions, delegate: delegate, scoring: { scoring($0, correctAnswers: answers) })
        flow.start()

        return Quiz(flow: flow)
    }
}

func scoring<Question: Hashable, Answer: Equatable>(_ answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
    return answers.reduce(0) { score, tupple in
        return score + (correctAnswers[tupple.key] == tupple.value ? 1 : 0)
    }
}
