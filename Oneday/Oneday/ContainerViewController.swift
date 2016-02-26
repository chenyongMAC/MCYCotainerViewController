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
  @IBOutlet weak var scrollView: UIScrollView!
  
  var selectedIndexOfMenu = 0 {
    didSet {
      if isViewLoaded() {
        updateMenuWithSelectedIndex(selectedIndexOfMenu)
      }
    }
  }
  let textColorForMenuLabel = UIColor(red: 0.866667, green: 0.866667, blue: 0.866667, alpha: 1.0)
  let selectedTextColorForMenuLabel = UIColor(red: 0.333333, green: 0.333333, blue: 0.333333, alpha: 1.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // In StoryBoard, I set constrains, but it doesn't work
    // So I set frames manully, Auto Layout bugs?
    menuView.frame.size.width = view.frame.width
    scrollView.frame.size = CGSize(width: view.frame.width, height: view.frame.width - 60)
    scrollView.contentSize = CGSize(width: scrollView.frame.width * 3, height: scrollView.frame.height)
    
    initailViewControllersInStoryboard(storyboard!)
  }

}

// MARK: - menu view configure
extension ContainerViewController {
  
  private func setupMenuViewWithTitles(titles: [String]) {
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
  
  private func configureLabelsInMenuView(menuView: UIView, withLabelsWidth labelsWidth: CGFloat) {
    guard let labels = menuView.subviews as? [UILabel] else{ return }
    var nextPositonOfLabels = (menuView.bounds.width - labelsWidth) / 2
    for (index, label) in labels.enumerate() {
      label.textColor = textColorForMenuLabel
      label.frame.size.height = 40
      label.frame.origin.x = nextPositonOfLabels
      label.userInteractionEnabled = true
      label.tag = 2000 + index
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "menuItemClicked:")
      label.addGestureRecognizer(tapGestureRecognizer)
      nextPositonOfLabels += label.frame.width + MENU_LABEL_MARGIN
    }
    
    // the first item of menu view
    labels.first?.textColor = selectedTextColorForMenuLabel
  }
  
  func menuItemClicked(recognizer: UITapGestureRecognizer) {
    guard let sender = recognizer.view as? UILabel else { return }
    let selectedIndex = sender.tag - 2000
    UIView.animateWithDuration(0.5, animations: {
      self.scrollView.contentOffset.x = CGFloat(selectedIndex) * self.scrollView.frame.width
      self.updateMenuWithSelectedIndex(selectedIndex)
      }, completion: nil)
  }
  
  private func updateMenuWithSelectedIndex(selectedIndex: Int) {
    guard let labels = menuView.subviews as? [UILabel] else { return }
    for (index, label) in labels.enumerate() {
      if selectedIndex == index {
        label.textColor = selectedTextColorForMenuLabel
      }else {
        label.textColor = textColorForMenuLabel
      }
    }
  }
  
}

// MARK: - Children View Controllers
extension ContainerViewController {
  
  func initailViewControllersInStoryboard(storyboard: UIStoryboard) {
    let mainVC = storyboard.instantiateViewControllerWithIdentifier("MainVC")
    let mainTabVC = storyboard.instantiateViewControllerWithIdentifier("MainTabVC") as! UITableViewController
    let rightVC = storyboard.instantiateViewControllerWithIdentifier("RightVC")
    setupMenuViewWithTitles([mainVC.title!, mainTabVC.title!,rightVC.title!])
    setupViewsWidthViewControllers([mainVC, mainTabVC, rightVC])
  }
  
  private func setupViewsWidthViewControllers(viewControllers: [UIViewController]) {
    let scrollViewBounds = scrollView.bounds
    for (index, viewController) in viewControllers.enumerate() {
      let view = viewController.view
      view.frame = CGRect(origin: CGPoint(x: CGFloat(index) * scrollViewBounds.width, y: 0), size: scrollViewBounds.size)
      scrollView.addSubview(viewController.view)
    }
  }
  
}

// Scroll view delegate
extension ContainerViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    selectedIndexOfMenu = Int((scrollView.contentOffset.x + scrollView.frame.width / 2) / scrollView.frame.width)
  }
  
}

