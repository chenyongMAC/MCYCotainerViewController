//
//  ViewController.swift
//  Oneday
//
//  Created by iYww on 16/2/25.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit

let MENU_LABEL_MARGIN: CGFloat = 10

class ContainerViewController: UIViewController {

  @IBOutlet weak var menuView: UIView!
  
  var selectedIndexOfMenu = 0
  let textColorForMenuLabel = UIColor(red: 0.866667, green: 0.866667, blue: 0.866667, alpha: 1.0)
  let selectedTextColorForMenuLabel = UIColor(red: 0.333333, green: 0.333333, blue: 0.333333, alpha: 1.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // In StoryBoard, I set constrains, but it doesn't work
    // So I set frames manully, Auto Layout bugs?
    menuView.frame.size.width = view.frame.width
    
    setupMenuViewWithTitles(["mainVC", "mainTabVC", "YYImageDemo"])
  }

}

// MARK: - menu view configure
extension ContainerViewController {
  
  func setupMenuViewWithTitles(titles: [String]) {
    var widthOfLabels: CGFloat = 0.0
    var labels = [UILabel]()
    for title in titles {
      let label = UILabel(frame: CGRect.zero)
      label.text = title
      label.font = UIFont.systemFontOfSize(16)
      label.sizeToFit()
      widthOfLabels += label.frame.width
      labels.append(label)
      menuView.addSubview(label)
    }
    widthOfLabels += MENU_LABEL_MARGIN * CGFloat(labels.count - 1)
    configureLabelsInMenuView(menuView, withLabelsWidth: widthOfLabels)
  }
  
  func configureLabelsInMenuView(menuView: UIView, withLabelsWidth labelsWidth: CGFloat) {
    guard let labels = menuView.subviews as? [UILabel] else{ return }
    var nextPositonOfLabels = (menuView.bounds.width - labelsWidth) / 2
    for (index, label) in labels.enumerate() {
      label.textColor = textColorForMenuLabel
      label.frame.size.height = 40
      label.frame.origin.x = nextPositonOfLabels
      label.userInteractionEnabled = true
      label.tag = 2000 + index
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "menuItemSwitched:")
      label.addGestureRecognizer(tapGestureRecognizer)
      nextPositonOfLabels += label.frame.width + MENU_LABEL_MARGIN
    }
    
    // the first item of menu view
    labels.first?.textColor = selectedTextColorForMenuLabel
  }
  
  func menuItemSwitched(recognizer: UITapGestureRecognizer) {
    guard let labels = menuView.subviews as? [UILabel] else { return }
    guard let sender = recognizer.view as? UILabel else { return }
    let selectedIndex = sender.tag - 2000
    for (index, label) in labels.enumerate() {
      if selectedIndex == index {
        label.textColor = selectedTextColorForMenuLabel
      }else {
        label.textColor = textColorForMenuLabel
      }
    }
  }
  
}

