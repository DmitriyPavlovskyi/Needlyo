import AVFoundation
import Speech

final class SpeechRecognitionService {

    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer?

    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    init(locale: Locale = Locale(identifier: "uk-UA")) {
        speechRecognizer = SFSpeechRecognizer(locale: locale)
    }

    func requestAuthorization() async -> Bool {
        let speechStatus = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }

        let microphoneGranted = await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { isGranted in
                continuation.resume(returning: isGranted)
            }
        }

        return speechStatus == .authorized && microphoneGranted
    }

    func startRecognition(
        onUpdate: @escaping (SpeechRecognitionSnapshot) -> Void,
        onFinish: @escaping () -> Void
    ) throws {
        stopRecognition()

        guard let speechRecognizer, speechRecognizer.isAvailable else {
            throw SpeechRecognitionError.recognizerUnavailable
        }

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest.shouldReportPartialResults = true
        self.recognitionRequest = recognitionRequest

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.removeTap(onBus: 0)
        inputNode.installTap(
            onBus: 0,
            bufferSize: 1024,
            format: recordingFormat
        ) { [weak recognitionRequest] buffer, _ in
            recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            Task { @MainActor in
                if let result {
                    onUpdate(
                        SpeechRecognitionSnapshot(
                            text: result.bestTranscription.formattedString,
                            segments: result.bestTranscription.segments.map {
                                SpeechRecognitionSegment(
                                    text: $0.substring,
                                    timestamp: $0.timestamp,
                                    duration: $0.duration
                                )
                            }
                        )
                    )
                }

                if error != nil || result?.isFinal == true {
                    self.stopRecognition()
                    onFinish()
                }
            }
        }
    }

    func stopRecognition() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }

        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil

        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

}

enum SpeechRecognitionError: LocalizedError {

    case recognizerUnavailable

    var errorDescription: String? {
        switch self {
        case .recognizerUnavailable:
            return "Speech recognition is unavailable right now."
        }
    }

}
