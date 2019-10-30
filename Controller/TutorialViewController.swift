//
//  TutorialViewController.swift
//  GetReady
//
//  Created by leonardo palinkas on 30/10/19.
//  Copyright © 2019 leonardo palinkas. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    var slides:[Slide] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        
    }
    
    func createSlides() -> [Slide] {

    let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self , options: nil)?.first as! Slide
    slide1.imageView.image = UIImage(named: "1")
    
    let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self , options: nil)?.first as! Slide
    slide1.imageView.image = UIImage(named: "2")
    
    let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self , options: nil)?.first as! Slide
    slide1.imageView.image = UIImage(named: "3")
    
    let slide4:Slide = Bundle.main.loadNibNamed("Slide", owner: self , options: nil)?.first as! Slide
    slide1.imageView.image = UIImage(named: "4")
    
    let slide5:Slide = Bundle.main.loadNibNamed("Slide", owner: self , options: nil)?.first as! Slide
    slide1.imageView.image = UIImage(named: "5")
    
    let slide6:Slide = Bundle.main.loadNibNamed("Slide", owner: self , options: nil)?.first as! Slide
    slide1.imageView.image = UIImage(named: "6")
    
    let slide7:Slide = Bundle.main.loadNibNamed("Slide", owner: self , options: nil)?.first as! Slide
    slide1.imageView.image = UIImage(named: "7")
    
    let slide8:Slide = Bundle.main.loadNibNamed("Slide", owner: self , options: nil)?.first as! Slide
    slide1.imageView.image = UIImage(named: "8")
    
    let slide9:Slide = Bundle.main.loadNibNamed("Slide", owner: self , options: nil)?.first as! Slide
    slide1.imageView.image = UIImage(named: "9")
    
    let slide10:Slide = Bundle.main.loadNibNamed("Slide", owner: self , options: nil)?.first as! Slide
    slide1.imageView.image = UIImage(named: "10")
    
    
    return [slide1, slide2, slide3, slide4, slide5, slide6, slide7, slide8, slide9, slide10]
    }
    
    func setupSlideScrollView(slides : [Slide]) {
           scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
           scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
           scrollView.isPagingEnabled = true
           
           for i in 0 ..< slides.count {
               slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
               scrollView.addSubview(slides[i])
           }
       }
    

}
