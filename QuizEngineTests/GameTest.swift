//
//  GameTest.swift
//  QuizEngine
//
//  Created by Eldorbek on 12/05/22.
//

import Foundation
import XCTest
import QuizEngine

class GameTest: XCTestCase {
    let router = RouterSpy()
    var game: Game<String, String, RouterSpy>!

    func test_startGame_answerZeroOutOfTwoCorrectly_scoresZero() {
        game = startGame(questions: ["Q1", "Q2"], router: router, answers: ["Q1": "A1", "Q2": "A2"])

        router.answerCallback("wrong")
        router.answerCallback("wrong")

        XCTAssertEqual(router.routedResult?.score, 0)
    }

    func test_startGame_answerOneOutOfTwoCorrectly_scoresOne() {
        game = startGame(questions: ["Q1", "Q2"], router: router, answers: ["Q1": "A1", "Q2": "A2"])

        router.answerCallback("A1")
        router.answerCallback("wrong")

        XCTAssertEqual(router.routedResult?.score, 1)
    }

    func test_startGame_answerTwoOutOfTwoCorrectly_scoresTwo() {
        game = startGame(questions: ["Q1", "Q2"], router: router, answers: ["Q1": "A1", "Q2": "A2"])

        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedResult?.score, 2)
    }
}


