//
//  SubmissionViewModel.swift
//  BoSS
//
//  Created by Nikita Leonov on 2/28/15.
//  Copyright (c) 2015 Bureau of Street Services. All rights reserved.
//

import Foundation
import CoreLocation
import ReactiveCocoa

class SubmissionViewModel {
    internal var photo: UIImage? {
        return model.photo
    }
    internal let locationUpdate: RACSignal!

    internal var location: CLLocation? {
        set {
            model.location = newValue
            locationUpdateSubject.sendNext(model.location!)
        }
        get {
            return model.location
        }
    }
    private var model: Submission
    private let locationUpdateSubject: RACSubject = RACSubject()
    
    init(image:UIImage, locationService: LocationServiceProtocol) {
        locationUpdate = locationUpdateSubject
        
        model = Submission()
        model.photo = image
        
        locationService.currentLocation().take(1).subscribeNext { [weak self] (location) -> Void in
            if let location = location as? CLLocation {
                self?.location = location
            }
        }
    }
}