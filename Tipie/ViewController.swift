//
//  ViewController.swift
//  Tippin'
//
//  Created by Neftali Samarey on 1/17/19.
//  Copyright © 2019 Neftali Samarey. All rights reserved.
//

// NOTES: If Percentage is selected before input is made, 0 index value will be calculated first.

import UIKit

enum TipPercentage : Float {
    case Fiften = 0.15
    case Twenty = 0.20
    case TwentyFive = 0.25
}

class ViewController: UIViewController, SliderPercentageInputDelegate {
    
    
    
    var slider : Overlay?
    
    // LABELS
    @IBOutlet weak var dueLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    var overlayTouchArea = UIView()
    @IBOutlet weak var totalParentView: UIView!
    
   // CONTROL COMPONENTS
    @IBOutlet weak var tipSegmentParentView: UIView!
    @IBOutlet weak var tipSegmentControl: UISegmentedControl!
    var cleanSlate : Bool?
    var decimalCounter = 0
    var selectedIndex = 0
    let navigatorBar = UIView()
   
    // COMPUTING VARIABLE
    var displayQuantity : Float = 0.0
    var tip: Float = 0.0
    var total: Float = 0.0
    
    // FEEDBACK GENERATOR
    let selectedFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    let clearedGenerator = UINotificationFeedbackGenerator()
    var tapGestureRecorgnizer : UITapGestureRecognizer?
    

    // COMPUTING BASED ON INPUT
    @IBAction func actionKey(_ sender: UIButton) {
        
        selectedFeedbackGenerator.impactOccurred()
        
        self.tipSegmentControl.isEnabled = true
        
        // remove the 0
        if let slateClean = cleanSlate {
            if slateClean == false {
                self.dueLabel.text = ""
            }
        
        }
        
        cleanSlate = true
        
        //TODO: - IMPLEMENT THE CLEARING OF THE 0 & TRUNCATE VALUE
        self.dueLabel.text! = self.dueLabel.text! + String(sender.tag-1)
        displayQuantity = Float(self.dueLabel.text!)!
        
        
        print("Zero: \(displayQuantity)")
       
        tip = displayQuantity * TipPercentage.Fiften.rawValue
        total = displayQuantity + tip
        
        if let didCleanSlate = cleanSlate {
            print("Resporting: \(didCleanSlate)")
        }
        self.tipLabel.text = String(format: "$%0.2f",tip)
        self.totalLabel.text = String(format: "$%0.2f",total)
    
    }
    
    
    // MARK: - DECIMAL INSERTION METHOD
    @IBAction func decimalInsertion(_ sender: UIButton) {
        
        selectedFeedbackGenerator.impactOccurred()

        let decimalChar: [Int: String] = [sender.tag-1: "."]
        
        guard displayQuantity != 0.0  else {
            return
        }

        if decimalCounter == 0 {
             self.dueLabel.text = self.dueLabel.text! + decimalChar[sender.tag-1]!
        }
        
        // Increment the counter
        decimalCounter += 1
    }
    
    // MARK: - DELETE ENTIRE ENTRY (CLEAR ALL)
    @IBAction func deleteEntry(_ sender: Any) {
        
        self.tipSegmentControl.isEnabled = false
        self.decimalCounter = 0
        self.displayQuantity = 0
        self.tip = 0
        self.total = 0
        self.dueLabel.text = "0"
        self.tipLabel.text = "0"
        self.totalLabel.text = "0"
        self.cleanSlate = false
        self.tipSegmentControl.selectedSegmentIndex = 0
        resetSegmentBarPosition()
        clearedGenerator.notificationOccurred(.success)
        
    }
    
    
    // MARK: - Styling and constraining the Segmented control
    fileprivate func loadCustomSegmentControl() {
        
        tipSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        tipSegmentControl.backgroundColor = .clear
        tipSegmentControl.tintColor = .clear
        
        // Style the segment control
        tipSegmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Lato-Light", size: 20)!,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        tipSegmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Lato-Semibold", size: 20)!,
            NSAttributedString.Key.foregroundColor: UIColor.cleanIndigo()
            ], for: .selected)
  
        tipSegmentControl.apportionsSegmentWidthsByContent = true
        // Segment control anchors (tipSegmentParentView)
        tipSegmentControl.topAnchor.constraint(equalTo: self.tipSegmentParentView.topAnchor, constant: 10).isActive = true
        tipSegmentControl.bottomAnchor.constraint(equalTo: self.tipSegmentParentView.bottomAnchor, constant: -10).isActive = true
        tipSegmentControl.leadingAnchor.constraint(equalTo: self.tipSegmentParentView.leadingAnchor, constant: 3).isActive = true
        tipSegmentControl.trailingAnchor.constraint(equalTo: self.tipSegmentParentView.trailingAnchor, constant: -3).isActive = true
        
        // Segment control bottom view
      
        navigatorBar.translatesAutoresizingMaskIntoConstraints = false
        self.tipSegmentParentView.addSubview(navigatorBar)
        navigatorBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
        //navigatorBar.widthAnchor.constraint(equalTo: tipSegmentControl.widthAnchor, multiplier: 1 / CGFloat(tipSegmentControl.numberOfSegments)).isActive = true
        navigatorBar.widthAnchor.constraint(equalToConstant: self.tipSegmentParentView.bounds.width/4).isActive = true
        tipSegmentParentView.bottomAnchor.constraint(equalTo: navigatorBar.bottomAnchor).isActive = true
//        navigatorBar.frame = CGRect(x: 0, y: 0, width: 100, height: 10)
        navigatorBar.backgroundColor = UIColor.cleanIndigo()
       
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tipie"
        self.cleanSlate = false
        loadCustomSegmentControl()
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.font : UIFont(name: "Lato-Light", size: 24)!
        ]
        

        navigationController?.navigationBar.titleTextAttributes = attributes
        selectedFeedbackGenerator.prepare()
        self.tipSegmentControl.isEnabled = false
        self.overlayTouchArea.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func resetSegmentBarPosition() {
        UIView.animate(withDuration: 0.2) {
             self.navigatorBar.frame.origin.x = (self.tipSegmentParentView.frame.width / CGFloat(self.tipSegmentControl.numberOfSegments)) * CGFloat(self.tipSegmentControl.selectedSegmentIndex)
        }
    }
    
    
    @IBAction func tipControl(_ sender: Any) {
        
        selectedFeedbackGenerator.impactOccurred()
        selectedIndex = tipSegmentControl.selectedSegmentIndex
        
        // Update the Bottom bar
        UIView.animate(withDuration: 0.2) {
            //buttonBar.frame.origin.x = (segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)) * CGFloat(segmentedControl.selectedSegmentIndex)
            self.navigatorBar.frame.origin.x = (self.tipSegmentParentView.frame.width / CGFloat(self.tipSegmentControl.numberOfSegments)) * CGFloat(self.tipSegmentControl.selectedSegmentIndex)
        }
        
        guard displayQuantity != 0.0 else {
            return
        }
        
        switch tipSegmentControl.selectedSegmentIndex {
        case 0:
            tip = displayQuantity * TipPercentage.Fiften.rawValue
            total = displayQuantity + tip
            self.animateLabelsWith(tip: tip, total: total)

        case 1:
            tip = displayQuantity * TipPercentage.Twenty.rawValue
             total = displayQuantity + tip
          
            self.animateLabelsWith(tip: tip, total: total)

        case 2:
            tip = displayQuantity * TipPercentage.TwentyFive.rawValue
            total = displayQuantity + tip
            self.animateLabelsWith(tip: tip, total: total)

        case 3:
        
            sliderCustomView()
            
        default:
            print("No other selection made")
        }
    }
    
    // MARK: DELEGATE
    func updateTipPercentage(currentPercentage: Float?) {
        if let percentile = currentPercentage {
           let roundedValue = (percentile * 100).rounded() / 100
            computeCustomTip(input: roundedValue)
        }
    }
    
    
    // MARK: - SLIDER CALCULATION
    func computeCustomTip(input: Float!)  {
        print("Recieved: \(input!)")
        tip = displayQuantity * Float(input)
        total = displayQuantity + self.tip
        animateLabelsWith(tip: tip, total: total) // pass by reference
    }

    
    // MARK: - ANIMATION
    fileprivate func animateLabelsWith(tip: Float, total: Float) {
        
        let roundedValueTip = (tip * 100).rounded() / 100
        let roundedTotal = (total * 100).rounded() / 100
//        print("Tip: \(roundedValueTip)\n Total: \(roundedTotal)")
        UIView.animate(withDuration: 0.2) {
            
            self.tipLabel.text = String(format: "$%0.2f", roundedValueTip)
            self.totalLabel.text = String(format: "$%0.2f", roundedTotal)
        }
        
    }
    
    
   
    
    
  
  
    
    // MARK: - Slider Component
     func sliderCustomView() {
        
        slider = Overlay(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3))
        slider?.translatesAutoresizingMaskIntoConstraints = false
        if let slider = slider {
            view.addSubview(slider)
            view.addSubview(overlayTouchArea)
            slider.delegate = self
            // Touch area
            overlayTouchArea.backgroundColor = UIColor.clear
            overlayTouchArea.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            overlayTouchArea.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            overlayTouchArea.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: 0).isActive = true
            invokeTouchArea()
            // FIXME: - Fixing the view to end at the bottom of the total view bottom
            slider.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height/2) + 60).isActive = true
            slider.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            slider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
           
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
            // end
        }
    }
    
    // Remove from the main view
    @objc func slideViewDown() {
        print("Called")
        
        if let slider = slider {
            
            // MAK: - Computing the overall height of the main view to be dismissed
            slider.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height/2) + 60).isActive = true
            slider.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
           
            UIView.animate(withDuration: 0.2, animations: {
                // Slide the view down below the bottom anchor of the main view
                 slider.center = CGPoint(x: self.view.center.x, y: self.view.frame.height + self.slider!.frame.height/2)
                self.view.layoutIfNeeded()
            }, completion: { (s) in
                slider.removeFromSuperview()
                self.overlayTouchArea.removeFromSuperview()
                self.slider = nil
          
            })
            
        }
    }
    
    
    // MARK: - Overlay custom area
    func invokeTouchArea() {
        tapGestureRecorgnizer = UITapGestureRecognizer(target: self, action: #selector(self.slideViewDown))
        overlayTouchArea.addGestureRecognizer(tapGestureRecorgnizer!)
    }
    
    
}
