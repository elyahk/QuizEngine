//
//  Question.swift
//  QuizApp
//
//  Created by Eldorbek on 15/05/22.
//

import Foundation

public enum Question<T: Hashable>: Hashable {
    case singleAnswer(T)
    case multipleAnswer(T)

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .singleAnswer(let value):
            hasher.combine(value)
        case .multipleAnswer(let value):
            hasher.combine(value)
        }
    }
}
