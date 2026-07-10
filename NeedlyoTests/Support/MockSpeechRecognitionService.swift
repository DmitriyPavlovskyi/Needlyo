import Foundation
@testable import Needlyo

final class MockSpeechRecognitionService: SpeechRecognitionServicing {

    var authorizationResult = true
    var snapshotToDeliver: SpeechRecognitionSnapshot?
    var startRecognitionCallCount = 0
    var stopRecognitionCallCount = 0
    var autoFinish = true

    func requestAuthorization() async -> Bool {
        authorizationResult
    }

    func startRecognition(
        onUpdate: @escaping (SpeechRecognitionSnapshot) -> Void,
        onFinish: @escaping () -> Void
    ) throws {
        startRecognitionCallCount += 1

        if let snapshotToDeliver {
            onUpdate(snapshotToDeliver)
        }

        if autoFinish {
            onFinish()
        }
    }

    func stopRecognition() {
        stopRecognitionCallCount += 1
    }

}
