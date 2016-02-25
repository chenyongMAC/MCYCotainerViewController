//
//  ViewController.swift
//  Oneday
//
//  Created by iYww on 16/2/25.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

  @IBOutlet weak var menuView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupMenuViewWithTitles(["mainVC", "mainTabVC", "YYImageDemo"])
  }
  
  func setupMenuViewWithTitles(titles: [String]) {
    let labelMargin: CGFloat = 10
    var widthOfLabels: CGFloat = 0.0
    var labels = [UILabel]()
    var nextPositionOfLabels: CGFloat = 0.0
    for title in titles {
      let label = UILabel(frame: CGRect.zero)
      label.text = title
      label.sizeToFit()
      label.frame.size.height = 40
      labels.append(label)
      widthOfLabels += label.frame.width
    }
    widthOfLabels += labelMargin * CGFloat(labels.count - 1)
    nextPositionOfLabels = (view.bounds.width - widthOfLabels) / 2
    for label in labels {
      label.frame.origin.x = nextPositionOfLabels
      menuView.addSubview(label)
      nextPositionOfLabels += label.frame.width + labelMargin
    }
  }

}

