//
//  GeneratorPanel.swift
//  AudioKitSynthOne
//
//  Created by AudioKit Contributors on 7/23/17.
//  Copyright © 2017 AudioKit. All rights reserved.
//

import AudioKit
import AudioKitUI
import UIKit

class GeneratorsPanelController: PanelController {

    @IBOutlet weak var morph1Selector: MorphSelector!
    @IBOutlet weak var morph2Selector: MorphSelector!

    @IBOutlet weak var morph1SemitoneOffset: MIDIKnob!
    @IBOutlet weak var morph2SemitoneOffset: MIDIKnob!
    @IBOutlet weak var morph2Detuning: MIDIKnob!
    @IBOutlet weak var morphBalance: MIDIKnob!
    @IBOutlet weak var morph1Volume: MIDIKnob!
    @IBOutlet weak var morph2Volume: MIDIKnob!
    @IBOutlet weak var glideKnob: MIDIKnob!

    @IBOutlet weak var cutoff: MIDIKnob!
    @IBOutlet weak var resonance: MIDIKnob!

    @IBOutlet weak var subVolume: MIDIKnob!
    @IBOutlet weak var subOctaveDown: ToggleButton!
    @IBOutlet weak var subIsSquare: ToggleButton!
    @IBOutlet weak var isMonoToggle: ToggleButton!

    @IBOutlet weak var fmVolume: MIDIKnob!
    @IBOutlet weak var fmAmount: MIDIKnob!

    @IBOutlet weak var noiseVolume: MIDIKnob!

    @IBOutlet weak var masterVolume: MIDIKnob!

    @IBOutlet weak var filterTypeToggle: FilterTypeButton!
    @IBOutlet weak var displayContainer: UIView!

    @IBOutlet weak var sequencerToggle: FlatToggleButton!
    @IBOutlet weak var tempoStepper: TempoStepper!

    @IBOutlet weak var legatoModeToggle: ToggleButton!
    @IBOutlet weak var widenToggle: FlatToggleButton!
    @IBOutlet weak var oscBandlimitEnable: ToggleButton!
    
    var audioPlot: AKNodeOutputPlot!
    var isAudioPlotFilled: Bool = false
    var midiKnobs = [MIDIKnob]()

    public override func viewDidLoad() {
        super.viewDidLoad()
        currentPanel = .generators
        let c = Conductor.sharedInstance

        // Defaults, limits
        morph1SemitoneOffset.onlyIntegers = true
        morph1SemitoneOffset.range = c.getRange(.morph1SemitoneOffset)
        morph2SemitoneOffset.onlyIntegers = true
        morph2SemitoneOffset.range = c.getRange(.morph2SemitoneOffset)
        morph1SemitoneOffset.knobSensitivity = 0.004
        morph2SemitoneOffset.knobSensitivity = 0.004
        morph2Detuning.range = c.getRange(.morph2Detuning)
        morphBalance.range = c.getRange(.morphBalance)
        morph1Volume.range = c.getRange(.morph1Volume)
        morph2Volume.range = c.getRange(.morph2Volume)
        glideKnob.range = c.getRange(.glide)
        glideKnob.taper = 2
        cutoff.range = c.getRange(.cutoff)
        cutoff.taper = 3
        resonance.range = c.getRange(.resonance)
        subVolume.range = c.getRange(.subVolume)
        fmVolume.range = c.getRange(.fmVolume)
        fmAmount.range = c.getRange(.fmAmount)
        noiseVolume.range = c.getRange(.noiseVolume)
        masterVolume.range = c.getRange(.masterVolume)
        tempoStepper.maxValue = c.getMaximum(.arpRate)
        tempoStepper.minValue = c.getMinimum(.arpRate)

        conductor.bind(morph1Selector, to: .index1)
        conductor.bind(morph2Selector, to: .index2)
        conductor.bind(morph1SemitoneOffset, to: .morph1SemitoneOffset)
        conductor.bind(morph2SemitoneOffset, to: .morph2SemitoneOffset)
        conductor.bind(morph2Detuning, to: .morph2Detuning)
        conductor.bind(morphBalance, to: .morphBalance)
        conductor.bind(morph1Volume, to: .morph1Volume)
        conductor.bind(morph2Volume, to: .morph2Volume)
        conductor.bind(cutoff, to: .cutoff)
        conductor.bind(resonance, to: .resonance)
        conductor.bind(subVolume, to: .subVolume)
        conductor.bind(subOctaveDown, to: .subOctaveDown)
        conductor.bind(subIsSquare, to: .subIsSquare)
        conductor.bind(fmVolume, to: .fmVolume)
        conductor.bind(fmAmount, to: .fmAmount)
        conductor.bind(noiseVolume, to: .noiseVolume)
        conductor.bind(isMonoToggle, to: .isMono)
        conductor.bind(glideKnob, to: .glide)
        conductor.bind(filterTypeToggle, to: .filterType)
        conductor.bind(masterVolume, to: .masterVolume)
        conductor.bind(legatoModeToggle, to: .monoIsLegato)
        conductor.bind(widenToggle, to: .widen)
        conductor.bind(sequencerToggle, to: .arpIsOn)
        conductor.bind(tempoStepper, to: .arpRate)
        conductor.bind(oscBandlimitEnable, to: .oscBandlimitEnable)

        // Setup Audio Plot Display
        setupAudioPlot()

        setupLinkStuff()
    }

    func setupAudioPlot() {
        audioPlot = AKNodeOutputPlot(Conductor.sharedInstance.tap, frame: CGRect(x: 0, y: 0, width: 172, height: 93))
        audioPlot.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.2431372549, blue: 0.262745098, alpha: 0)
        audioPlot.color = #colorLiteral(red: 0.9611048102, green: 0.509832561, blue: 0, alpha: 1)
        audioPlot.gain = 1
        audioPlot.shouldFill = false
        displayContainer.addSubview(audioPlot)

        // Add Tap Gesture Recognizer to AudioPlot
        let audioPlotTap = UITapGestureRecognizer(target: self,
                                                  action: #selector(GeneratorsPanelController.audioPlotToggled))
        audioPlot.addGestureRecognizer(audioPlotTap)
    }

    @objc func audioPlotToggled() {
        isAudioPlotFilled = !isAudioPlotFilled
        audioPlot.shouldFill = isAudioPlotFilled
    }
}
