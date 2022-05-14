//
//  File.swift
//  QuizEngine
//
//  Created by Eldorbek on 12/05/22.
//

import Foundation

public class Game<Question, Answer, R: Router> where R.Question == Question, R.Answer == Answer{
    let flow: Flow<Question, Answer, R>

    init(flow: Flow<Question, Answer, R>) {
        self.flow = flow
    }
}

public func startGame<Question, Answer, R: Router>(questions: [Question], router: R, answers: [Question: Answer]) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
    let flow = Flow(questions: questions, router: router, scoring: { _ in 1 })
    flow.start()

    return Game(flow: flow)
}
