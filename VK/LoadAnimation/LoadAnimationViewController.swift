//
//  LoadAnimationViewController.swift
//  VK
//
//  Created by Екатерина on 23.11.2021.
//

import UIKit

class LoadAnimationViewController: UIViewController {
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var sacondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animateIndicatirLoading()
    }
    

    func animateIndicatirLoading() {
        UIView.animate(withDuration: 0.5,
                       delay: 0, options: [.repeat, .autoreverse],
                       animations: { [weak self] in
                        self?.firstView.layer.opacity = 0
                       })
        UIView.animate(withDuration: 0.5,
                       delay: 0.25,
                       options: [.repeat, .autoreverse],
                       animations: { [weak self] in
                        self?.sacondView.layer.opacity = 0
                       })
        UIView.animate(withDuration: 0.5,
                       delay: 0.5,
                       options: [.repeat, .autoreverse],
                       animations: { [weak self] in
                        self?.thirdView.layer.opacity = 0
                       })
    }
}
