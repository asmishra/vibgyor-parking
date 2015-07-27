//
//  ViewController.h
//  vibgyor_mapview
//
//  Created by Anurag Mishra on 7/19/15.
//  Copyright (c) 2015 mojers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface firstViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLGeocoder *geoCoder;
@property (strong, nonatomic) CLPlacemark *placeMark;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl3;
- (IBAction)segmentedControl4:(id)sender;
- (IBAction)segmentedControl5:(UISegmentedControl *)sender;

- (IBAction)storeParkingLocation:(UIButton *)sender;
@property (strong, nonatomic) CLLocation *locationProperty;
@property (strong, nonatomic) IBOutlet UIButton *storeParkingLocationOutlet;

- (IBAction)routeFromLocation:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *routeFromLocation;

//source and destination Location properties
@property (strong, nonatomic) CLLocation *sourceLocation;
@property (strong, nonatomic) CLLocation *destLocation;


@end

