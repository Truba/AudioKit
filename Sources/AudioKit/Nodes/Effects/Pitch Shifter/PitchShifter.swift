// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// Faust-based pitch shfiter
public class PitchShifter: Node, AudioUnitContainer, Tappable, Toggleable {

    /// Unique four-letter identifier "pshf"
    public static let ComponentDescription = AudioComponentDescription(effect: "pshf")

    /// Internal type of audio unit for this node
    public typealias AudioUnitType = InternalAU

    /// Internal audio unit 
    public private(set) var internalAU: AudioUnitType?

    // MARK: - Parameters

    /// Specification details for shift
    public static let shiftDef = NodeParameterDef(
        identifier: "shift",
        name: "Pitch shift (in semitones)",
        address: akGetParameterAddress("PitchShifterParameterShift"),
        range: -24.0 ... 24.0,
        unit: .relativeSemiTones,
        flags: .default)

    /// Pitch shift (in semitones)
    @Parameter public var shift: AUValue

    /// Specification details for windowSize
    public static let windowSizeDef = NodeParameterDef(
        identifier: "windowSize",
        name: "Window size (in samples)",
        address: akGetParameterAddress("PitchShifterParameterWindowSize"),
        range: 0.0 ... 10_000.0,
        unit: .hertz,
        flags: .default)

    /// Window size (in samples)
    @Parameter public var windowSize: AUValue

    /// Specification details for crossfade
    public static let crossfadeDef = NodeParameterDef(
        identifier: "crossfade",
        name: "Crossfade (in samples)",
        address: akGetParameterAddress("PitchShifterParameterCrossfade"),
        range: 0.0 ... 10_000.0,
        unit: .hertz,
        flags: .default)

    /// Crossfade (in samples)
    @Parameter public var crossfade: AUValue

    // MARK: - Audio Unit

    /// Internal Audio Unit for PitchShifter
    public class InternalAU: AudioUnitBase {

        public override func getParameterDefs() -> [NodeParameterDef] {
            [PitchShifter.shiftDef,
             PitchShifter.windowSizeDef,
             PitchShifter.crossfadeDef]
        }

        public override func createDSP() -> DSPRef {
            akCreateDSP("PitchShifterDSP")
        }
    }

    // MARK: - Initialization

    /// Initialize this pitchshifter node
    ///
    /// - Parameters:
    ///   - input: Input node to process
    ///   - shift: Pitch shift (in semitones)
    ///   - windowSize: Window size (in samples)
    ///   - crossfade: Crossfade (in samples)
    ///
    public init(
        _ input: Node,
        shift: AUValue = 0,
        windowSize: AUValue = 1_024,
        crossfade: AUValue = 512
        ) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit

            self.shift = shift
            self.windowSize = windowSize
            self.crossfade = crossfade
        }
        connections.append(input)
    }
}
