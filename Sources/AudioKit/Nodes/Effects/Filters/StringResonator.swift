// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// StringResonator passes the input through a network composed of comb,
/// low-pass and all-pass filters, similar to the one used in some versions of the 
/// Karplus-Strong algorithm, creating a string resonator effect. The fundamental frequency 
/// of the “string” is controlled by the fundamentalFrequency.  
/// This operation can be used to simulate sympathetic resonances to an input signal.
/// 
public class StringResonator: Node, AudioUnitContainer, Tappable, Toggleable {

    /// Unique four-letter identifier "stre"
    public static let ComponentDescription = AudioComponentDescription(effect: "stre")

    /// Internal type of audio unit for this node
    public typealias AudioUnitType = InternalAU

    /// Internal audio unit 
    public private(set) var internalAU: AudioUnitType?

    // MARK: - Parameters

    /// Specification details for fundamentalFrequency
    public static let fundamentalFrequencyDef = NodeParameterDef(
        identifier: "fundamentalFrequency",
        name: "Fundamental Frequency (Hz)",
        address: akGetParameterAddress("StringResonatorParameterFundamentalFrequency"),
        range: 12.0 ... 10_000.0,
        unit: .hertz,
        flags: .default)

    /// Fundamental frequency of string.
    @Parameter public var fundamentalFrequency: AUValue

    /// Specification details for feedback
    public static let feedbackDef = NodeParameterDef(
        identifier: "feedback",
        name: "Feedback (%)",
        address: akGetParameterAddress("StringResonatorParameterFeedback"),
        range: 0.0 ... 1.0,
        unit: .percent,
        flags: .default)

    /// Feedback amount (value between 0-1). A value close to 1 creates a slower decay and a more pronounced resonance. Small values may leave the input signal unaffected. Depending on the filter frequency, typical values are > .9.
    @Parameter public var feedback: AUValue

    // MARK: - Audio Unit

    /// Internal Audio Unit for StringResonator
    public class InternalAU: AudioUnitBase {

        public override func getParameterDefs() -> [NodeParameterDef] {
            [StringResonator.fundamentalFrequencyDef,
             StringResonator.feedbackDef]
        }

        public override func createDSP() -> DSPRef {
            akCreateDSP("StringResonatorDSP")
        }
    }

    // MARK: - Initialization

    /// Initialize this filter node
    ///
    /// - Parameters:
    ///   - input: Input node to process
    ///   - fundamentalFrequency: Fundamental frequency of string.
    ///   - feedback: Feedback amount (value between 0-1). A value close to 1 creates a slower decay and a more pronounced resonance. Small values may leave the input signal unaffected. Depending on the filter frequency, typical values are > .9.
    ///
    public init(
        _ input: Node,
        fundamentalFrequency: AUValue = 100,
        feedback: AUValue = 0.95
        ) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit

            self.fundamentalFrequency = fundamentalFrequency
            self.feedback = feedback
        }
        connections.append(input)
    }
}
