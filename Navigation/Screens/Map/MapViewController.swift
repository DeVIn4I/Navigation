//
//  MapViewController.swift
//  Navigation
//
//  Created by Razumov Pavel on 18.08.2025.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private lazy var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        gestureRecognizer.minimumPressDuration = 1.0
        return gestureRecognizer
    }()
    
    private lazy var myPositionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(centerMyPosition), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        btn.setImage(UIImage(systemName: "location.fill", withConfiguration: config), for: .normal)
        btn.tintColor = .label
        return btn
    }()
    
    private lazy var choiceStyleMapButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(choiceStyleMap), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        btn.setImage(UIImage(systemName: "square.3.layers.3d", withConfiguration: config), for: .normal)
        btn.tintColor = .label
        return btn
    }()

    weak var coordinator: MapCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(mapView)
        view.addSubview(myPositionButton)
        view.addSubview(choiceStyleMapButton)
        
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.addGestureRecognizer(longPressGestureRecognizer)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setConstraints() {
        mapView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        myPositionButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        choiceStyleMapButton.snp.makeConstraints {
            $0.bottom.equalTo(myPositionButton.snp.top).offset(-16)
            $0.trailing.equalTo(myPositionButton)
        }
    }
    
    @objc
    private func centerMyPosition() {
        guard let location = locationManager.location else {
            locationManager.requestLocation()
            return
        }
        
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapView.setRegion(region, animated: true)
    }
    
    @objc
    private func addAnnotation(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        let point = gesture.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "New Pin"
        mapView.addAnnotation(pin)
        Haptic.impact(.medium)
    }
    
    @objc
    private func choiceStyleMap() {
        let alert = UIAlertController(title: "", message: "Выберете слой карты", preferredStyle: .actionSheet)
        let standard = UIAlertAction(title: "Стандартный", style: .default) { [weak self] _ in
            self?.mapView.mapType = .standard
        }
        let muted = UIAlertAction(title: "Затемненный", style: .default) { [weak self] _ in
            self?.mapView.mapType = .mutedStandard
        }
        let hybrid = UIAlertAction(title: "Реалистичный", style: .default) { [weak self] _ in
            self?.mapView.mapType = .hybrid
        }
        alert.addAction(standard)
        alert.addAction(muted)
        alert.addAction(hybrid)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .notDetermined:
            break
        default:
            manager.stopUpdatingLocation()
        }
    }
}

enum Haptic {

    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: style)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }

    static func selection() {
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator.selectionChanged()
    }

    static func notification(_ style:UINotificationFeedbackGenerator.FeedbackType) {
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(style)
    }
}
