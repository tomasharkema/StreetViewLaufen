//
//  ViewController.swift
//  StreetViewLaufen
//
//  Created by Tomas Harkema on 02-08-15.
//  Copyright (c) 2015 Tomas Harkema. All rights reserved.
//

import UIKit
import GoogleMaps

func randomInt(min: Int, max:Int) -> Int {
  return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

class ViewController: UIViewController {
  
  var panoView: GMSPanoramaView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    panoView = GMSPanoramaView(frame: CGRectZero)
    self.view = panoView
    
    let loc = ((52 + (Double(randomInt(0, 100000)) / 100000)), (4 + (Double(randomInt(0, 100000)) / 100000)))
    println(loc)
    
    panoView.moveNearCoordinate(CLLocationCoordinate2DMake(loc.0, loc.1))
    
    panoView.setAllGesturesEnabled(false)
    loopVerder()
  }
  
  func loopVerder() {
    if panoView.panorama != nil {
      
      var links = panoView.panorama.links as! [GMSPanoramaLink]
      
      let previousHeading = Double(panoView.camera.orientation.heading)
      
      let closestHeading = links.reduce(links.first!) { prev, el in
        let heading = abs(Double(el.heading) - previousHeading)
        let prevHeading = abs(Double(prev.heading) - previousHeading)
        
        if heading < prevHeading {
          return el
        } else {
          return prev
        }
      }
      panoView.moveToPanoramaID(closestHeading.panoramaID)
      panoView.camera = GMSPanoramaCamera(heading: Double(closestHeading.heading), pitch: 0, zoom: 1)
    }
    
    NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "loopVerder", userInfo: nil, repeats: false)
  }
  
}

