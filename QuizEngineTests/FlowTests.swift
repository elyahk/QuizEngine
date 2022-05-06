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
    let router: Router

    init(router: Router) {
        self.router = router
    }

    func start() {

    }

}

class FlowTests: XCTestCase {
    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        let router = RouterSpy()
        let sut = Flow(router: router)

        sut.start()

        XCTAssertEqual(router.routedQuestionCount, 0)
    }

    class RouterSpy: Router {
        var routedQuestionCount: Int = 0

        func routeTo(question: String) {

        }
    }
}
