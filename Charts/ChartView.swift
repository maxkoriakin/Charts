//
//  ChartView.swift
//  Charts
//
//  Created by Max Koriakin on 12/17/18.
//  Copyright © 2018 Max Koriakin. All rights reserved.
//

import UIKit

class ChartView: UIView {

    // MARK: - Lazy Properties
    lazy var xAxis: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    lazy var yAxis: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    // MARK: - Properties
    var count: Int = 0
    var yLines: [UIView] = []
    var dots: [ChartPoint] = []
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: CGRect.zero)
        setupAxis()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Axis
extension ChartView {
    // MARK: - Setup
    func setupAxis() {
        setupHorizontalAxis()
        setupVerticalAxis()
    }
    
    func setupHorizontalAxis() {
        addSubview(xAxis)
        xAxis.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            xAxis.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            xAxis.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            xAxis.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            xAxis.heightAnchor.constraint(equalToConstant: 3),
        ])
    }
    
    func setupVerticalAxis() {
        addSubview(yAxis)
        yAxis.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yAxis.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            yAxis.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            yAxis.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            yAxis.widthAnchor.constraint(equalToConstant: 3)
        ])
    }
    
    func setupDots(dots: [CGFloat]) {
        self.count = dots.count
        setupLines()
        let min: CGFloat = 0.0
        let max: CGFloat = 50.0
        self.layoutIfNeeded()
        for (index, dot) in dots.enumerated() {
            let dotView = ChartPoint()
            addSubview(dotView)
            dotView.backgroundColor = .blue
            let yHeight = xAxis.frame.minY - yAxis.frame.minY
            let height = max - min
            let yOffset: CGFloat = yHeight * dot / height
            dotView.translatesAutoresizingMaskIntoConstraints = false
            
            let coordinate = Coordinate(x: yLines[index].center.x, y: xAxis.center.y - yOffset)
            dotView.coordinate = coordinate
            NSLayoutConstraint.activate([
                dotView.centerYAnchor.constraint(equalTo: xAxis.centerYAnchor, constant: -yOffset),
                dotView.centerXAnchor.constraint(equalTo: yLines[index].centerXAnchor),
                dotView.widthAnchor.constraint(equalToConstant: 5),
                dotView.heightAnchor.constraint(equalToConstant: 5)
                ])
            self.dots.append(dotView)
        }
        drawChart()
    }
    
    func setupLines() {
        let width = xAxis.frame.width
        let step: CGFloat = width / CGFloat(count + 1)
        for i in 1 ... count {
            let line = UIView()
            addSubview(line)
            line.backgroundColor = .clear
            line.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                line.leadingAnchor.constraint(equalTo: yAxis.trailingAnchor, constant: (step * CGFloat(i))),
                line.topAnchor.constraint(equalTo: yAxis.topAnchor),
                line.bottomAnchor.constraint(equalTo: yAxis.bottomAnchor),
                line.widthAnchor.constraint(equalToConstant: 1)
                ])
            yLines.append(line)
        }
    }
    
    func drawChart() {
        let path = UIBezierPath()
        for (index,dot) in self.dots.enumerated() {
            if index != self.dots.count - 1 {
                guard let coordinate = dot.coordinate, let nextCoordinate = dots[index + 1].coordinate else { return }
                path.move(to: CGPoint(x: coordinate.x, y: coordinate.y))
                path.addLine(to: CGPoint(x: nextCoordinate.x, y: nextCoordinate.y))
            }
        }
        let pathLayer = CAShapeLayer()
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = UIColor.blue.cgColor
        pathLayer.lineWidth = 2.0
        self.layer.addSublayer(pathLayer)
    }
    
}
