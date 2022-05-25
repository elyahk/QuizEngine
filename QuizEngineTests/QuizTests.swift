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
        delegate.answerCompletion("wrong")
        delegate.answerCompletion("wrong")

        XCTAssertEqual(delegate.routedResult?.score, 0)
    }

    func test_startQuiz_answerOneOutOfTwoCorrectly_scoresOne() {
        delegate.answerCompletion("A1")
        delegate.answerCompletion("wrong")

        XCTAssertEqual(delegate.routedResult?.score, 1)
    }

    func test_startQuiz_answerTwoOutOfTwoCorrectly_scoresTwo() {
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")

        XCTAssertEqual(delegate.routedResult?.score, 2)
    }

    private class DelegateSpy: QuizDelegate {
        var answerCompletion: ((String) -> Void) = { _ in }
        var routedResult: Result<String, String>? = nil

        public func answer(for question: String, completion: @escaping (String) -> Void) {
            self.answerCompletion = completion
        }

        public func handle(result: Result<String, String>) {
            routedResult = result
        }
    }
}


