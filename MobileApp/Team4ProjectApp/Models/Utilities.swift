//
//  Utilities.swift
//  Team4ProjectApp
//
//  Created by Logan Harvell on 11/29/17.
//  Copyright © 2017 Logan Harvell. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
  
  func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
    
    let border = CALayer()
    
    switch edge {
    case UIRectEdge.top:
      border.frame = CGRect(x: 0, y: 0, width: self.frame.width,
                            height: thickness)
      break
    case UIRectEdge.bottom:
      border.frame = CGRect(x: 0, y: self.frame.height - thickness,
                            width: self.frame.width, height: thickness)
      break
    case UIRectEdge.left:
      border.frame = CGRect(x: 0, y: 0, width: thickness,
                            height: self.frame.height)
      break
    case UIRectEdge.right:
      border.frame = CGRect(x: self.frame.width - thickness, y: 0,
                            width: thickness, height: self.frame.height)
      break
    default:
      break
    }
    
    border.backgroundColor = color.cgColor;
    
    self.addSublayer(border)
  }
  
  func increaseSize(by: CGFloat) {
    self.frame.size.width += by
    self.frame.size.height += by
  }
  
}
