//
//  FlowTests.swift
//  QuizEngineTests
//
//  Created by Eldorbek on 06/05/22.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTests: XCTestCase {
    private let delegate = DelegateSpy()

    func test_start_withNoQuestions_doesNotDelegateQuestionHandling() {
        makeSUT(questions: []).start()

        XCTAssertTrue(delegate.handledQuestions.isEmpty)
    }

    func test_start_withOneQuestion_delegateCorrectQuestionHandling() {
        makeSUT(questions: ["Q1"]).start()

        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }

    func test_start_withOneQuestion_delegateCorrectQuestion_2Handling() {
        makeSUT(questions: ["Q2"]).start()

        XCTAssertEqual(delegate.handledQuestions, ["Q2"])
    }

    func test_start_withTwoQuestion_delegateFirstQuestionHandling() {
        makeSUT(questions: ["Q1", "Q2"]).start()

        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }

    func test_startTwice_withTwoQuestion_delegateFirstQuestionTwiceHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        sut.start()

        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q1"])
    }

    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestion_delegateSecondAndThirdQuestionHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()

        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")

        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q2", "Q3"])
    }

    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotDelegateAnotherQuestionHandling() {
        let sut = makeSUT(questions: ["Q1"])

        sut.start()
        delegate.answerCompletion("A1")

        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }

    func test_start_withOneQuestion_doesNotQompleteQuiz() {
        makeSUT(questions: ["Q1"]).start()

        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }

    func test_start_withNoQuestion_completeWithEmptyQuiz() {
        makeSUT(questions: []).start()

        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        XCTAssertTrue(delegate.completedQuizzes[0].isEmpty)
    }

    func test_startAndAnswerFirstQuestion_withOneQuestion_routesToResult() {
        let sut = makeSUT(questions: ["Q1"])

        sut.start()
        delegate.answerCompletion("A1")

        XCTAssertEqual(delegate.handledResult?.answers, ["Q1":"A1"])
    }

    func test_startAndAnswerFirstQuestion_withTwoQuestion_doesNotCompleteQuiz() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        delegate.answerCompletion("A1")

        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_routesToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")

        XCTAssertEqual(delegate.handledResult?.answers, ["Q1":"A1", "Q2":"A2"])
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_scores() {
        let sut = makeSUT(questions: ["Q1", "Q2"]) { _ in 10 }

        sut.start()
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")

        XCTAssertEqual(delegate.handledResult?.score, 10)
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_scoresWithRightAnswers() {
        var recievedAnswers = [String: String]()
        let sut = makeSUT(questions: ["Q1", "Q2"]) { answers in
            recievedAnswers = answers
            return 10
        }

        sut.start()
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")

        XCTAssertEqual(delegate.handledResult?.answers, recievedAnswers)
    }
    // MARK: - Helpers

    private func makeSUT(
        questions: [String],
        scoring: @escaping ([String: String]) -> Int = { _ in 0 }
    ) -> Flow<DelegateSpy> {
        return Flow(questions: questions, delegate: delegate, scoring: scoring)
    }

    private class DelegateSpy: QuizDelegate {
        var handledQuestions: [String] = []
        var answerCompletion: ((String) -> Void) = { _ in }
        var handledResult: Result<String, String>? = nil
        var completedQuizzes: [[(question: String, answer: String)]] = []

        func answer(for question: String, completion: @escaping AnswerComletion) {
            handledQuestions.append(question)
            self.answerCompletion = completion
        }

        func didCompleteQuiz(withAnswers: [(question: String, answer: String)]) {
            completedQuizzes.append(withAnswers)
        }

        func handle(result: Result<String, String>) {
            handledResult = result
        }
    }
}
