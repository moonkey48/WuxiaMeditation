//
//  MeditationSentence.swift
//  WuxiaMeditation
//
//  Created by Austin's Macbook Pro M3 on 6/15/24.
//

import Foundation

struct MeditationSentence {
    let id: UUID = UUID()
    let sentence: String
    let author: String
}

let dummyMeditationSentenceList: [MeditationSentence] = [
    MeditationSentence(sentence: "끝을 맺기를 처음과 같이 하면 실패가 없다.", author: "노자"),
    MeditationSentence(sentence: "그릇은 비어 있어야만 무엇을 담을 수가 있다.", author: "노자"),
    MeditationSentence(sentence: "우울한 사람은 과거에 살고,\n불안 사람은 미래에 살고,\n평안한 사람은 현재에 산다.", author: "노자"),
    MeditationSentence(sentence: "어디를 가든지 마음을 다해 가라. ", author: "공자"),
    MeditationSentence(sentence: "허물이 있다면, 버리기를 두려워말라.", author: "공자"),
    MeditationSentence(sentence: "앞날을 결정짓고자 하면 옛것을 공부하라. ", author: "공자"),
    MeditationSentence(sentence: "지나침은 모자람만 못하다. ", author: "공자"),
    MeditationSentence(sentence: "강직과 의연함, 소박함과 겸손함은 \n인(仁)에 가까우니라.", author: "공자"),
    MeditationSentence(sentence: "산을 움직이려 하는 이는\n작은 돌을 들어내는 일로 시작하느니라. ", author: "공자"),
    MeditationSentence(sentence: "진정한 앎은 자신이 얼마나 모르는 지를 아는 것이니라. ", author: "공자"),
    MeditationSentence(sentence: "어질지 않은 사람을 보면,\n속으로 스스로 반성하라.", author: "공자"),
    MeditationSentence(sentence: "거처는 마음을 변화시키고,\n수양은 몸을 변화시킨다.", author: "맹자"),
    MeditationSentence(sentence: "스스로 돌아봐서 잘못이 없다면,\n천만인이 가로막아도 나는 가리라.", author: "맹자"),
    MeditationSentence(sentence: "세상은 고통으로 가득하지만 한편 그것을 이겨내는 일로도 가득차 있다", author: "헬렌 켈러"),
    MeditationSentence(sentence: "쓰러진 자 망할까 두렵지 않고, 낮춘 자 거만할까 두렵지 않다", author: "J.버넌"),
    MeditationSentence(sentence: "노동은 세개의 큰 악, 즉, 지루함, 부도덕, 그리고 가난을 제거한다.", author: "괴테"),
]


