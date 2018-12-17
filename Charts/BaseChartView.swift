//
//  BaseChartView.swift
//  Charts
//
//  Created by Max Koriakin on 12/17/18.
//  Copyright © 2018 Max Koriakin. All rights reserved.
//

import UIKit

protocol BaseChartViewDelegate: class {
    
    var axesOffset: UIEdgeInsets { get }
    var axesWidth: CGFloat { get }
}

class BaseChartView: UIView {

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
    weak var delegate: BaseChartViewDelegate?
    
    var count: Int = 0
    var yLines: [UIView] = []
    var dots: [ChartPoint] = []
    
    // MARK: - Life Cycle
    init(delegate: BaseChartViewDelegate) {
        self.delegate = delegate
        super.init(frame: CGRect.zero)
        setupAxis()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Axis
extension BaseChartView {
    // MARK: - Setup
    func setupAxis() {
        setupHorizontalAxis()
        setupVerticalAxis()
    }
    
    func setupHorizontalAxis() {
        addSubview(xAxis)
        xAxis.translatesAutoresizingMaskIntoConstraints = false
        guard let inset = delegate?.axesOffset, let width = delegate?.axesWidth else { return }
        
        NSLayoutConstraint.activate([
            xAxis.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            xAxis.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset.left),
            xAxis.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: inset.right),
            xAxis.heightAnchor.constraint(equalToConstant: width),
        ])
    }
    
    func setupVerticalAxis() {
        addSubview(yAxis)
        yAxis.translatesAutoresizingMaskIntoConstraints = false
        guard let inset = delegate?.axesOffset, let width = delegate?.axesWidth else { return }

        NSLayoutConstraint.activate([
            yAxis.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: inset.left),
            yAxis.topAnchor.constraint(equalTo: self.topAnchor, constant: inset.top),
            yAxis.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: inset.bottom),
            yAxis.widthAnchor.constraint(equalToConstant: width)
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
