import Foundation

struct SpeechRecognitionSnapshot {

    let text: String
    let segments: [SpeechRecognitionSegment]

}

struct SpeechRecognitionSegment {

    let text: String
    let timestamp: TimeInterval
    let duration: TimeInterval

}
