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
    let router = RouterSpy()

    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSUT(questions: []).start()

        XCTAssertTrue(router.routedQuestions.isEmpty)
    }

    func test_start_withOneQuestion_routesToCorrectQuestion() {
        makeSUT(questions: ["Q1"]).start()

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_start_withOneQuestion_routesToCorrectQuestion_2() {
        makeSUT(questions: ["Q2"]).start()

        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }

    func test_start_withTwoQuestion_routesToFirstQuestion() {
        makeSUT(questions: ["Q1", "Q2"]).start()

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_startTwice_withTwoQuestion_routesToFirstQuestionTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }

    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestion_routesToSecondAndThirdQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()

        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }

    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotRouteToAnotherQuestion() {
        let sut = makeSUT(questions: ["Q1"])

        sut.start()
        router.answerCallback("A1")

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_start_withNoQuestion_routesToResult() {
        let sut = makeSUT(questions: [])

        sut.start()

        XCTAssertEqual(router.routedResult?.answers, [:])
    }

    func test_start_withOneQuestion_doesNotRoutesToResult() {
        let sut = makeSUT(questions: ["Q1"])

        sut.start()

        XCTAssertNil(router.routedResult)
    }

    func test_startAndAnswerFirstQuestion_withOneQuestion_routesToResult() {
        let sut = makeSUT(questions: ["Q1"])

        sut.start()
        router.answerCallback("A1")

        XCTAssertEqual(router.routedResult?.answers, ["Q1":"A1"])
    }

    func test_startAndAnswerFirstQuestion_withTwoQuestion_doesNotRoutesToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        router.answerCallback("A1")

        XCTAssertNil(router.routedResult)
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_routesToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedResult?.answers, ["Q1":"A1", "Q2":"A2"])
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_scores() {
        let sut = makeSUT(questions: ["Q1", "Q2"]) { _ in 10 }

        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedResult?.score, 10)
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_scoresWithRightAnswers() {
        var recievedAnswers = [String: String]()
        let sut = makeSUT(questions: ["Q1", "Q2"]) { answers in
            recievedAnswers = answers
            return 10
        }

        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedResult?.answers, recievedAnswers)
    }
    // MARK: - Helpers

    private func makeSUT(
        questions: [String],
        scoring: @escaping ([String: String]) -> Int = { _ in 0 }
    ) -> Flow<String, String, RouterSpy> {
        return Flow(questions: questions, router: router, scoring: scoring)
    }

    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var answerCallback: ((String) -> Void) = { _ in }
        var routedResult: Result<String, String>? = nil

        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }

        func routeTo(result: Result<String, String>) {
            routedResult = result
        }
    }
}
