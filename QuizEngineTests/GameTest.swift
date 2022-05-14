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
    func test_startGame_answerOneOutOfTwoCorrectly_scores1() {
        let router = RouterSpy()
        let game = startGame(questions: ["Q1", "Q2"], router: router, answers: ["Q1": "A1", "Q2": "A2"])

        router.answerCallback("A1")
        router.answerCallback("wrong")

        XCTAssertEqual(router.routedResult?.score, 1)
    }
}


