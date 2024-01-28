//
//  ViewController.swift
//  HM17
//
//  Created by Evgeny Sakun on 22.01.24.
//


import UIKit

class ViewController: UIViewController {
    let circleView = UIView()
    let tapGesture = UITapGestureRecognizer()
    let longPressGesture = UILongPressGestureRecognizer()
    let panGesture = UIPanGestureRecognizer()
    var buttonsHStackView = UIStackView()
    
    var symbolsArray = ["↑", "↓", "←", "→"]
    var buttonsArray: [UIButton] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        setupCircle()
        setupButtonsStack()
    }

    func setupCircle() {
        view.addSubview(circleView)

        circleView.frame = CGRect(x: view.center.x, y: view.center.y, width: 130, height: 130)
        circleView.layer.cornerRadius = circleView.frame.width / 2
        circleView.layer.borderWidth = 3
        circleView.layer.borderColor = UIColor.black.cgColor
        circleView.backgroundColor = UIColor(red: CGFloat(Double.random(in: 1 / 255 ... 255 / 255)), green: CGFloat(Double.random(in: 1 / 255 ... 255 / 255)), blue: CGFloat(Double.random(in: 1 / 255 ... 254 / 255)), alpha: 1.0)

        tapGesture.addTarget(self, action: #selector(circleTapped))
        longPressGesture.addTarget(self, action: #selector(circleLongPressed))
        panGesture.addTarget(self, action: #selector(circlePanned))

        circleView.addGestureRecognizer(tapGesture)
        circleView.addGestureRecognizer(longPressGesture)
        circleView.addGestureRecognizer(panGesture)
    }

    @objc func circleTapped(_ gesture: UITapGestureRecognizer) {
        circleView.removeFromSuperview()

        let safeAreaWidth = Int(view.safeAreaLayoutGuide.layoutFrame.size.width)
        let stackBottom = Int(buttonsHStackView.frame.maxY)
        let safeAreaBottom = Int(view.safeAreaLayoutGuide.layoutFrame.maxY)

        let circleSide = Int(circleView.bounds.size.width)

        circleView.frame = CGRect(x: Int.random(in: 1 ..< (safeAreaWidth - circleSide)), y: Int.random(in: (stackBottom + circleSide) ..< (safeAreaBottom - circleSide)), width: circleSide, height: circleSide)
        circleView.backgroundColor = UIColor(red: CGFloat(Double.random(in: 1 / 255 ... 255 / 255)), green: CGFloat(Double.random(in: 1 / 255 ... 255 / 255)), blue: CGFloat(Double.random(in: 1 / 255 ... 254 / 255)), alpha: 1.0)

        view.addSubview(circleView)
    }

    @objc func circleLongPressed(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            print("LongPressed")
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .autoreverse, animations: {
                self.circleView.transform = CGAffineTransform(scaleX: 2, y: 2)
            }, completion: { _ in
                self.circleView.transform = .identity
            })
        }
    }

    @objc func circlePanned(_ gesture: UIPanGestureRecognizer) {
        UIView.animate(withDuration: 0.05) {
            self.circleView.center = gesture.location(in: self.circleView.superview)
        }
    }
    
    func setupButtonsStack() {
        buttonsHStackView.axis = .horizontal
        buttonsHStackView.alignment = .center
        buttonsHStackView.distribution = .fillEqually
        buttonsHStackView.spacing = 6

        buttonsHStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(buttonsHStackView)

        setupHStackConstraints()

        setupButtonsArray()
        buttonsArray.forEach { button in
            buttonsHStackView.addArrangedSubview(button)
        }
        setupButtonsConstraints()
    }

    func setupButtonsArray() {
        symbolsArray.forEach { symbol in
            let moveButton = UIButton()
            moveButton.backgroundColor = UIColor.orange
            buttonsArray.append(moveButton)

            setupButtonView(button: moveButton, title: symbol)
        }
    }

    func setupButtonView(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 40)
        button.backgroundColor = UIColor.systemYellow
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 40

        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let circleLeft = Int(circleView.frame.minX)
        let circleRight = Int(circleView.frame.maxX)
        let circleBottom = Int(circleView.frame.maxY)
        let circleTop = Int(circleView.frame.minY)
        let circleSide = Int(circleView.bounds.size.width)

        if sender.titleLabel?.text == "↑" {
            if circleTop > Int(buttonsHStackView.frame.maxY + 30) {
                UIView.animate(withDuration: 0.2) {
                    self.circleView.frame = CGRect(x: circleLeft, y: circleTop - 30, width: circleSide, height: circleSide)
                }
            }
        } else if sender.titleLabel?.text == "↓" {
            if circleBottom < Int(view.safeAreaLayoutGuide.layoutFrame.maxY - 30) {
                UIView.animate(withDuration: 0.2) {
                    self.circleView.frame = CGRect(x: circleLeft, y: circleTop + 30, width: circleSide, height: circleSide)
                }
            }
        } else if sender.titleLabel?.text == "←" {
            if circleLeft > 30 {
                UIView.animate(withDuration: 0.2) {
                    self.circleView.frame = CGRect(x: circleLeft - 30, y: circleTop, width: circleSide, height: circleSide)
                }
            }
        } else if sender.titleLabel?.text == "→" {
            if circleRight < Int(UIScreen.main.bounds.size.width) - 30 {
                UIView.animate(withDuration: 0.2) {
                    self.circleView.frame = CGRect(x: circleLeft + 30, y: circleTop, width: circleSide, height: circleSide)
                }
            }
        }
    }
    
    func setupHStackConstraints() {
        NSLayoutConstraint.activate([
            buttonsHStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            buttonsHStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    func setupButtonsConstraints() {
        buttonsArray.forEach({ button in
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 80),
                button.heightAnchor.constraint(equalToConstant: 80),
            ])
        })
    }
    
}

