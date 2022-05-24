//
//  RouterSpy.swift
//  QuizEngineTests
//
//  Created by Eldorbek on 12/05/22.
//

import QuizEngine

public class RouterSpy: Router {
    var routedQuestions: [String] = []
    var answerCallback: ((String) -> Void) = { _ in }
    var routedResult: Result<String, String>? = nil

    public func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
        routedQuestions.append(question)
        self.answerCallback = answerCallback
    }

    public func routeTo(result: Result<String, String>) {
        routedResult = result
    }
}
