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
    
    private var nodes: [CLLocationCoordinate2D] = [] {
        didSet {
            clearPinsButton.isHidden = nodes.isEmpty ? true : false
            routeButton.isHidden = nodes.isEmpty ? true : false
        }
    }
    
    private lazy var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        gestureRecognizer.minimumPressDuration = 0.7
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
    
    private lazy var routeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        btn.setImage(
            UIImage(
                systemName: "point.bottomleft.forward.to.arrow.triangle.scurvepath.fill",
                withConfiguration: config
            ),
            for: .normal
        )
        btn.tintColor = .label
        btn.isHidden = true
        return btn
    }()
    
    private lazy var clearPinsButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(clearPins), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 8
        btn.setTitle("Очистить", for: .normal)
        btn.tintColor = .systemBackground
        btn.backgroundColor = .label
        btn.layer.opacity = 0.7
        btn.isHidden = true
        return btn
    }()
    
    private lazy var slidingView: RouteView = {
        $0.layer.cornerRadius = 46
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = true
        return $0
    }(RouteView())
    
    private var slidingViewBottomConstraint: NSLayoutConstraint?
    
    weak var coordinator: MapCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        [mapView, myPositionButton,
         choiceStyleMapButton, routeButton,
         clearPinsButton, slidingView
        ].forEach { view.addSubview($0) }
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.addGestureRecognizer(longPressGestureRecognizer)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        slidingView.closeBlock = { [weak self] in
            self?.didTapPlusButton()
        }
        
        slidingView.routeBlock = { [weak self] transport in
            self?.showRoute(with: transport)
        }
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
        
        routeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        clearPinsButton.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        slidingView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(160)
        }
        
        let bottomConstraint = slidingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        slidingViewBottomConstraint = bottomConstraint
        NSLayoutConstraint.activate([bottomConstraint])
    }
    
    private func showLocationServicesAlert() {
        let alert = UIAlertController(
            title: "Геолокация выключена",
            message: "Чтобы приложение работало корректно, включите геолокацию в настройках устройства.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Открыть настройки", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func didTapPlusButton() {
        let isViewRaised = slidingViewBottomConstraint?.constant == -160
        
        if isViewRaised {
            slidingViewBottomConstraint?.constant = 0
            UIView.animate(withDuration: 0.35, animations: {
                self.slidingView.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.slidingView.isHidden = true
                self.slidingView.alpha = 1
            })
        } else {
            if slidingView.isHidden {
                slidingView.isHidden = false
                slidingView.alpha = 0
                self.view.layoutIfNeeded()
            }
            slidingViewBottomConstraint?.constant = -160
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.88,
                           initialSpringVelocity: 0.7,
                           options: [.curveEaseInOut, .allowUserInteraction]) {
                self.slidingView.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    private func centerMyPosition() {
        
        let status = locationManager.authorizationStatus
        
        guard status == .authorizedWhenInUse, status == .authorizedAlways else {
            showLocationServicesAlert()
            return
        }
        
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
        nodes.append(coordinate)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "Точка \(nodes.count)"
        mapView.addAnnotation(pin)
        Haptic.impact(.medium)
    }
    
    @objc
    private func choiceStyleMap() {
        let alert = UIAlertController(title: "Выберете слой карты", message: "", preferredStyle: .actionSheet)
        let standard = UIAlertAction(title: "Стандартный", style: .default) { [weak self] _ in
            self?.mapView.mapType = .standard
        }
        let muted = UIAlertAction(title: "Затемненный", style: .default) { [weak self] _ in
            self?.mapView.mapType = .mutedStandard
        }
        let hybrid = UIAlertAction(title: "Спутник", style: .default) { [weak self] _ in
            self?.mapView.mapType = .hybrid
        }
        alert.addAction(standard)
        alert.addAction(muted)
        alert.addAction(hybrid)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc
    private func showRoute(with transport: MKDirectionsTransportType) {
        guard let start = mapView.userLocation.location?.coordinate ?? locationManager.location?.coordinate,
              !nodes.isEmpty else { return }
        
        mapView.removeOverlays(mapView.overlays)
        
        var routes: [MKRoute] = []
        let points: [CLLocationCoordinate2D] = [start] + nodes
        
        func buildLeg(_ i: Int) {
            guard i + 1 < points.count else {
                routes.forEach { mapView.addOverlay($0.polyline) }
                let rect = routes.map { $0.polyline.boundingMapRect }
                    .reduce(MKMapRect.null) { $0.union($1) }
                mapView.setVisibleMapRect(
                    rect,
                    edgePadding: .init(top: 45, left: 35, bottom: 165, right: 35),
                    animated: true
                )
                return
            }
            
            let req = MKDirections.Request()
            req.source = MKMapItem(placemark: .init(coordinate: points[i]))
            req.destination = MKMapItem(placemark: .init(coordinate: points[i + 1]))
            req.transportType = transport
            req.requestsAlternateRoutes = false
            
            MKDirections(request: req).calculate { response, error in
                if let route = response?.routes.first {
                    routes.append(route)
                } else {
                    print("Route leg \(i) error:", error?.localizedDescription ?? "unknown")
                }
                buildLeg(i + 1)
            }
        }
        buildLeg(0)
    }
    
    @objc
    private func clearPins() {
        nodes = []
        let toRemove = mapView.annotations.filter { !($0 is MKUserLocation) }
        mapView.removeAnnotations(toRemove)
        mapView.removeOverlays(mapView.overlays)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            if CLLocationManager.locationServicesEnabled() {
                manager.requestLocation()
            } else {
                showLocationServicesAlert()
            }
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            manager.stopUpdatingLocation()
            showLocationServicesAlert()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error:", error.localizedDescription)
        
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .systemTeal
        render.lineWidth = 6.0
        return render
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
