//
//  GameTest.swift
//  QuizEngine
//
//  Created by Eldorbek on 12/05/22.
//

import Foundation
import XCTest
import QuizEngine

@available(*, deprecated)
class DeprecatedGameTest: XCTestCase {
    private let delegate = DelegateSpy()

    func test_startGame_answerZeroOutOfTwoCorrectly_scoresZero() {
        Quiz.start(questions: ["Q1", "Q2"], delegate: delegate, answers: ["Q1": "A1", "Q2": "A2"])
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")

        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        asswertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
    }

    private func asswertEqual(_ a1: [(String, String)], _ a2: [(String, String)], file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(a1.elementsEqual(a2, by: ==))
    }

    private class DelegateSpy: QuizDelegate {
        var answerCompletion: ((String) -> Void) = { _ in }
        var completedQuizzes: [[(question: String, answer: String)]] = []

        func answer(for question: String, completion: @escaping AnswerComletion) {
            self.answerCompletion = completion
        }

        func didCompleteQuiz(withAnswers: [(question: String, answer: String)]) {
            completedQuizzes.append(withAnswers)
        }

        func handle(result: Result<String, String>) { }
    }
}


