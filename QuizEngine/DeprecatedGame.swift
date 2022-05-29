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
    let flow = Flow(questions: questions, delegate: QuizDelegateToRouterAdapter(router, correctAnswers: answers))
    flow.start()

    return Game(flow: flow)
}

@available(*, deprecated)
private class QuizDelegateToRouterAdapter<R:Router>: QuizDelegate where R.Answer: Equatable {
    let router: R
    let correctAnswers: [R.Question: R.Answer]

    init(_ router: R, correctAnswers: [R.Question: R.Answer]) {
        self.router = router
        self.correctAnswers = correctAnswers
    }

    func answer(for question: R.Question, completion: @escaping R.AnswerCallback) {
        router.routeTo(question: question, answerCallback: completion)
    }

    func didCompleteQuiz(withAnswers answers: [(question: R.Question, answer: R.Answer)]) {
        let answerDictionary = answers.reduce([R.Question: R.Answer]()) { acc, tuple in
            var acc = acc
            acc[tuple.question] = tuple.answer
            return acc
        }
        let result = Result(answers: answerDictionary, score: scoring(answerDictionary, correctAnswers: correctAnswers))
        router.routeTo(result: result)
    }

    func handle(result: Result<R.Question, R.Answer>) { }
}


