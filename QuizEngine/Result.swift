//
//  Result.swift
//  QuizEngine
//
//  Created by Eldorbek on 15/05/22.
//

public struct Result<Question: Hashable, Answer> {
    public let answers: [Question: Answer]
    public let score: Int

    public init(answers: [Question: Answer], score: Int) {
        self.answers = answers
        self.score = score
    }
}
