//
//  RouteView.swift
//  Navigation
//
//  Created by Razumov Pavel on 18.08.2025.
//

import UIKit
import MapKit

final class RouteView: UIView {
    
    private var transport: MKDirectionsTransportType?
    
    var closeBlock: (() -> Void)?
    var routeBlock: ((MKDirectionsTransportType) -> Void)?
    
    private lazy var walkButton: UIButton = {
        $0.setImage(UIImage(systemName: "figure.walk"), for: .normal)
        $0.tintColor = .systemBackground
        $0.backgroundColor = .label
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(setTransport), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    
    private lazy var carButton: UIButton = {
        $0.setImage(UIImage(systemName: "car"), for: .normal)
        $0.tintColor = .label
        $0.backgroundColor = .systemBackground
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(setTransport), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    
    private lazy var busButton: UIButton = {
        $0.setImage(UIImage(systemName: "bus.fill"), for: .normal)
        $0.tintColor = .label
        $0.backgroundColor = .systemBackground
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(setTransport), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    
    private lazy var transportStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 40
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView(arrangedSubviews: [walkButton, carButton, busButton]))
    
    private lazy var makeRouteButton: UIButton = {
        $0.setTitle("Построить маршрут", for: .normal)
        $0.layer.cornerRadius = 14
        $0.tintColor = .systemBackground
        $0.backgroundColor = .label
        $0.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton(type: .system))
    
    private lazy var closeButton: UIButton = {
        $0.setTitle("Закрыть", for: .normal)
        $0.layer.cornerRadius = 14
        $0.tintColor = .systemBackground
        $0.backgroundColor = .label
        $0.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton(type: .system))
    
    private lazy var buttonsStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 16
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView(arrangedSubviews: [closeButton, makeRouteButton]))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [walkButton, carButton, busButton].forEach {
            $0.layer.cornerRadius = $0.bounds.height / 2
        }
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        
        addSubview(transportStackView)
        addSubview(buttonsStackView)
        
        buttonsStackView.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.bottom.leading.trailing.equalToSuperview().inset(16)
        }
        
        transportStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(46)
        }
        
        walkButton.snp.makeConstraints { $0.height.width.equalTo(46) }
        carButton.snp.makeConstraints { $0.height.width.equalTo(46) }
        busButton.snp.makeConstraints { $0.height.width.equalTo(46) }
    }

    @objc
    private func setTransport(_ sender: UIButton) {
        switch sender {
        case walkButton:
            configUIButton(sender)
            transport = .walking
        case carButton:
            configUIButton(sender)
            transport = .automobile
        case busButton:
            configUIButton(sender)
            transport = .transit
        default:
            break
        }
    }
    
    @objc
    private func closeButtonTapped() {
        closeBlock?()
    }
    
    @objc
    private func routeButtonTapped() {
        routeBlock?(transport ?? .walking)
    }
    
    private func configUIButton(_ button: UIButton) {
        [walkButton, carButton, busButton].forEach { selectedButton in
            if selectedButton == button {
                selectedButton.tintColor = .systemBackground
                selectedButton.backgroundColor = .label
            } else {
                selectedButton.tintColor = .label
                selectedButton.backgroundColor = .systemBackground
            }
        }
    }
}
