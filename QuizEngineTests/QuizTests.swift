//
//  QuizTests.swift
//  QuizEngineTests
//
//  Created by Eldorbek on 25/05/22.
//

import Foundation
import XCTest
import QuizEngine

@available(*, deprecated)
class QuizTests: XCTestCase {
    private let delegate = DelegateSpy()
    private var game: Quiz!

    override func setUp() {
        super.setUp()

        game = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate, answers: ["Q1": "A1", "Q2": "A2"])
    }

    func test_startQuiz_answerZeroOutOfTwoCorrectly_scoresZero() {
        delegate.answerCallback("wrong")
        delegate.answerCallback("wrong")

        XCTAssertEqual(delegate.routedResult?.score, 0)
    }

    func test_startQuiz_answerOneOutOfTwoCorrectly_scoresOne() {
        delegate.answerCallback("A1")
        delegate.answerCallback("wrong")

        XCTAssertEqual(delegate.routedResult?.score, 1)
    }

    func test_startQuiz_answerTwoOutOfTwoCorrectly_scoresTwo() {
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")

        XCTAssertEqual(delegate.routedResult?.score, 2)
    }

    private class DelegateSpy: Router, QuizDelegate {
        var answerCallback: ((String) -> Void) = { _ in }
        var routedResult: Result<String, String>? = nil

        func routeTo(question: String, answerCallback: @escaping AnswerCallback) {
            handle(question: question, answerCallback: answerCallback)
        }

        public func handle(question: String, answerCallback: @escaping (String) -> Void) {
            self.answerCallback = answerCallback
        }

        func routeTo(result: Result<String, String>) {
            handle(result: result)
        }

        public func handle(result: Result<String, String>) {
            routedResult = result
        }
    }
}


