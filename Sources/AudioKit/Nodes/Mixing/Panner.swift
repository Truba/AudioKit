// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// Stereo Panner
public class Panner: Node, AudioUnitContainer, Tappable, Toggleable {

    /// Unique four-letter identifier "pan2"
    public static let ComponentDescription = AudioComponentDescription(effect: "pan2")

    /// Internal type of audio unit for this node
    public typealias AudioUnitType = InternalAU

    /// Internal audio unit 
    public private(set) var internalAU: AudioUnitType?

    // MARK: - Parameters

    /// Specification details for pan
    public static let panDef = NodeParameterDef(
        identifier: "pan",
        name: "Panning. A value of -1 is hard left, and a value of 1 is hard right, and 0 is center.",
        address: akGetParameterAddress("PannerParameterPan"),
        range: -1 ... 1,
        unit: .generic,
        flags: .default)

    /// Panning. A value of -1 is hard left, and a value of 1 is hard right, and 0 is center.
    @Parameter public var pan: AUValue

    // MARK: - Audio Unit

    /// Internal Audio Unit for Panner
    public class InternalAU: AudioUnitBase {

        public override func getParameterDefs() -> [NodeParameterDef] {
            [Panner.panDef]
        }

        public override func createDSP() -> DSPRef {
            akCreateDSP("PannerDSP")
        }
    }

    // MARK: - Initialization

    /// Initialize this panner node
    ///
    /// - Parameters:
    ///   - input: Input node to process
    ///   - pan: Panning. A value of -1 is hard left, and a value of 1 is hard right, and 0 is center.
    ///
    public init(
        _ input: Node,
        pan: AUValue = 0
        ) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit

            self.pan = pan
        }
        connections.append(input)
    }
}
