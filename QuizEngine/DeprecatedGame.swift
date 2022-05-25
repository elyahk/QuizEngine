//
//  File.swift
//  QuizEngine
//
//  Created by Eldorbek on 12/05/22.
//

import Foundation

@available(*, deprecated, message: "This Router will be removed in the future")
public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer

    typealias AnswerCallback = (Answer) -> Void
    func routeTo(question: Question, answerCallback: @escaping AnswerCallback)
    func routeTo(result: Result<Question, Answer>)
}

@available(*, deprecated)
public class Game<Question, Answer, R: Router> {
    let flow: Any

    init(flow: Any) {
        self.flow = flow
    }
}

@available(*, deprecated)
public func startGame<Question, Answer: Equatable, R: Router>(questions: [Question], router: R, answers: [Question: Answer]) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
    let flow = Flow(questions: questions, delegate: QuizDelegateToRouterAdapter(router), scoring: { scoring($0, correctAnswers: answers) })
    flow.start()

    return Game(flow: flow)
}

@available(*, deprecated)
private class QuizDelegateToRouterAdapter<R:Router>: QuizDelegate {
    let router: R

    init(_ router: R) {
        self.router = router
    }

    func handle(question: R.Question, answerCallback: @escaping R.AnswerCallback) {
        router.routeTo(question: question, answerCallback: answerCallback)
    }

    func handle(result: Result<R.Question, R.Answer>) {
        router.routeTo(result: result)
    }
}


