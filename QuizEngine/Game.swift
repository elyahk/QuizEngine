//
//  File.swift
//  QuizEngine
//
//  Created by Eldorbek on 12/05/22.
//

import Foundation

public func startGame<Question: Hashable, Answer, R: Router>(questions: [Question], router: R, answers: [Question: Answer]) where R.Question == Question, R.Answer == Answer {

}
