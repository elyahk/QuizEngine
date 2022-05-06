//
//  FlowTests.swift
//  QuizEngineTests
//
//  Created by Eldorbek on 06/05/22.
//

import Foundation
import XCTest

protocol Router {
    func routeTo(question: String)
}

class Flow {
    let questions: [String]
    let router: Router

    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }

    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion)
        }
    }
}

class FlowTests: XCTestCase {
    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: [], router: router)

        sut.start()

        XCTAssertTrue(router.routedQuestions.isEmpty)
    }

    func test_start_withOneQuestion_routesToCorrectQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1"], router: router)

        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_start_withOneQuestion_routesToCorrectQuestion_2() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q2"], router: router)

        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }

    func test_start_withTwoQuestion_routesToFirstQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1", "Q2"], router: router)

        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_startTwice_withTwoQuestion_routesToFirstQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1", "Q2"], router: router)

        sut.start()
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }

    class RouterSpy: Router {
        var routedQuestionCount: Int = 0
        var routedQuestion: String = ""
        var routedQuestions: [String] = []

        func routeTo(question: String) {
            routedQuestionCount += 1
            routedQuestion = question
            routedQuestions.append(question)
        }
    }
}
