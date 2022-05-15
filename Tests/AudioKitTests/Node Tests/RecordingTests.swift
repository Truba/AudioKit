// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
@testable import AudioKit
import AVFoundation
import XCTest

#if !os(tvOS)
/// Tests for engine.inputNode - note can't be tested without an Info.plist
class RecordingTests: AudioFileTestCase {
    func testMultiChannelRecording() throws {
        guard Bundle.main.object(forInfoDictionaryKey: "NSMicrophoneUsageDescription") != nil else {
            Log("Unsupported test: To record audio, you must include the NSMicrophoneUsageDescription in your Info.plist.",
                type: .error)
            return
        }

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("_testMultiChannelRecording")

        if !FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.createDirectory(at: url,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        }

        let expectation = XCTestExpectation(description: "recordWithPermission")

        AVCaptureDevice.requestAccess(for: .audio) { allowed in
            Log("requestAccess", allowed)
            do {
                // Record channels 3+4 in a multichannel device
                // let channelMap: [Int32] = [2, 3]
                // for test assume mono first channel
                let channelMap: [Int32] = [0]
                try self.recordWithLatency(url: url, channelMap: channelMap, ioLatency: 12345)
                expectation.fulfill()

            } catch {
                XCTFail(error.localizedDescription)
            }
        }

        try FileManager.default.removeItem(at: url)
        wait(for: [expectation], timeout: 10)
    }

    /// unable to test this in AudioKit due to the lack of the Info.plist, but this should be addressed
    func recordWithLatency(url: URL, channelMap: [Int32], ioLatency: AVAudioFrameCount = 0) throws {
        // pull from channels 3+4 - needs to work with the device being tested
        // var channelMap: [Int32] = [2, 3] // , 4, 5

        let engine = AudioEngine()

        let channelMap: [Int32] = [0] // mono first channel

        let recorder = MultiChannelInputNodeTap(inputNode: engine.avEngine.inputNode)
        recorder.ioLatency = ioLatency
        try engine.start()
        recorder.directory = url
        recorder.prepare(channelMap: channelMap)
        recorder.record()

        wait(for: 3)

        recorder.stop()
        recorder.recordEnabled = false

        wait(for: 1)

        engine.stop()
    }

    func testOpenCloseFile() {
        let fileManager = FileManager.default
        let filename = UUID().uuidString + ".m4a"
        let fileUrl = fileManager.temporaryDirectory.appendingPathComponent(filename)

        var settings = Settings.audioFormat.settings
        settings[AVFormatIDKey] = kAudioFormatMPEG4AAC
        settings[AVLinearPCMIsNonInterleaved] = NSNumber(value: false)

        var outFile = try? AVAudioFile(
            forWriting: fileUrl,
            settings: settings)

        let engine = AudioEngine()
        let osc = PlaygroundOscillator()
        let recorder = try? NodeRecorder(node: osc)
        recorder?.openFile(file: &outFile)
        engine.output = osc

        try? engine.start()
        osc.start()
        try? recorder?.record()
        wait(for: 2)
        recorder?.stop()
        osc.stop()
        engine.stop()
        recorder?.closeFile(file: &outFile)
        guard let recordedFile = recorder?.audioFile else {
            XCTFail("Couldn't open recorded audio file!")
            return
        }
        XCTAssert(recordedFile.length > 0)
    }
}
#endif
