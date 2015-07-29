//
//  ViewController.m
//  vibgyor_mapview
//
//  Created by Anurag Mishra on 7/19/15.
//  Copyright (c) 2015 mojers. All rights reserved.
//

#import "firstViewController.h"

@interface firstViewController ()

@end

@implementation firstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.locationManager = [[CLLocationManager alloc] init];
    [self.mapView setDelegate:self];
    [self.locationManager setDelegate:self];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization]; // Add This Line iOS 8
    
    // Do any additional setup after loading the view, typically from a nib.
    self.mapView.mapType = MKMapTypeSatellite;
    self.mapView.zoomEnabled = YES;

    //Try to get user location?
    [self.view addSubview:self.mapView];
    [self.mapView addSubview:self.segmentedControl3];
    [self.mapView addSubview:self.storeParkingLocationOutlet];
    self.mapView.showsUserLocation = YES;
    self.mapView.mapType = MKMapTypeStandard;
    
    [self.mapView addSubview:self.routeFromLocation];
}

//This method is entered only when we simulate a location in Xcode (or when we are running on a phone)
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations[0] != nil)
        self.locationProperty = locations[0]; //To use in UIButton

    //zoom into that part of the map where user is located
    MKCoordinateRegion region;
    region.center.longitude = self.locationProperty.coordinate.longitude;
    region.center.latitude = self.locationProperty.coordinate.latitude;
    region.span.longitudeDelta = 0.1;
    region.span.latitudeDelta = 0.1;
    
    [self.mapView setRegion:region animated:YES]; //change map to point to current location
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)segmentedControlIndexChanged:(id)sender {
    
    NSLog(@"segmentedControlIndexChanged");
}


- (IBAction)segmentedControl4:(id)sender {
    NSLog(@"segmentedControlIndexChanged2");

}

- (IBAction)segmentedControl5:(UISegmentedControl *)sender {
    NSLog(@"segmentedControlIndexChanged3");
    if (sender.selectedSegmentIndex == 0 )
        self.mapView.mapType = MKMapTypeStandard;
    else if (sender.selectedSegmentIndex ==  1)
        self.mapView.mapType = MKMapTypeSatellite;
    else if (sender.selectedSegmentIndex == 2)
        self.mapView.mapType = MKMapTypeHybrid;
    
}

- (IBAction)storeParkingLocation:(UIButton *)sender {
    
    self.geoCoder = [[CLGeocoder alloc] init];
    CLLocation *location = self.locationProperty;
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //Put code here
        if (error == nil && [placemarks count] > 0) {
            self.placeMark = [placemarks lastObject];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
        
        //Anurag - PUT THIS CODE HERE (as the reverse geocoding process is an ASYNCH CALL)
        if (self.placeMark != nil) {
            //Areas of interest - doesn't have much information inbuilt
            for (int i = 0; i < [self.placeMark.areasOfInterest count]; i++) {
                NSLog(@"Areas of interest = %@", self.placeMark.areasOfInterest[i]);
            }
            //Address
            NSLog(@"Address: %@ %@, %@, %@, %@", self.placeMark.subThoroughfare, self.placeMark.thoroughfare, self.placeMark.locality, self.placeMark.postalCode, self.placeMark.country);
        }
        
        //Annotate the map
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = self.locationProperty.coordinate; //The location received inside this function
        NSMutableString *parkingLocation = [[NSMutableString alloc] initWithFormat:@"%@ %@, %@",self.placeMark.subThoroughfare, self.placeMark.thoroughfare, self.placeMark.locality];
        point.title = parkingLocation;
        [self.mapView addAnnotation:point];
    
        NSLog(@"Parking location saved at %@", self.locationProperty.description);
        //Store this location as source location
        self.sourceLocation = self.locationProperty;
        //Anurag - ASYNCH CALL HANDLING
        
        /******************************************/
        //Add a tester for MKLocalSearchRequest
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        request.naturalLanguageQuery = @"indian restaurants"; //set NL query phrase
        
        MKCoordinateRegion region;
        region.center.longitude = self.sourceLocation.coordinate.longitude;
        region.center.latitude = self.sourceLocation.coordinate.latitude;
        region.span.longitudeDelta = 0.1;
        region.span.latitudeDelta = 0.1;
        
        request.region = region; //set region for the query
        
        MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
        [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
            if (!error) {
                for (MKMapItem *mapItem in [response mapItems]) {
                    NSLog(@"Name: %@, Placemark title: %@", [mapItem name], [[mapItem placemark] title]);
                }
            } else {
                NSLog(@"Search Request Error: %@", [error localizedDescription]);
            }
        
        //response has mapitems with information for our use
        for (MKMapItem *mapItem in [response mapItems]) {
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            point.coordinate = self.locationProperty.coordinate; //The location received inside this function
            NSMutableString *responseString = [[NSMutableString alloc] initWithFormat:@"%@", mapItem.name];
            point.title = responseString;
            NSLog(@"response string: %@ and coordinates (%f,%f)", point.title, point.coordinate.latitude, point.coordinate.longitude);
            [self.mapView addAnnotation:point];
            point = nil; //clean up the pointer?
        }
            self.mapView.userTrackingMode=YES;
            [self.mapView setRegion:region animated:YES]; //change map to point to current location
            [self.mapView regionThatFits:region];



        }];
        /******************************************/
        
        
    }];
    
    //Hide button after click
    self.storeParkingLocationOutlet.hidden =  YES;

}

- (IBAction)routeFromLocation:(UIButton *)sender {
    
    self.destLocation = self.locationProperty;
    
    CLLocationCoordinate2D coord1 =
    CLLocationCoordinate2DMake(self.sourceLocation.coordinate.latitude, self.sourceLocation.coordinate.longitude);
    
    CLLocationCoordinate2D coord2 =
    CLLocationCoordinate2DMake(self.destLocation.coordinate.latitude, self.destLocation.coordinate.longitude);
    
    MKPlacemark *srcLoc = [[MKPlacemark alloc]
                          initWithCoordinate:coord1 addressDictionary:nil];
    
    MKPlacemark *dstLoc = [[MKPlacemark alloc]
                          initWithCoordinate:coord2 addressDictionary:nil];
    
    MKMapItem *mapItem1 = [[MKMapItem alloc] initWithPlacemark:srcLoc];
    MKMapItem *mapItem2 = [[MKMapItem alloc] initWithPlacemark:dstLoc];
    
//    NSArray *mapItems = @[mapItem1, mapItem2];
    [mapItem1 setName:@"Your Car"];
    [mapItem2 setName:@"You"];
    
    //HACK: change mapview to look at source?
    MKCoordinateRegion region;
    region.center.longitude = self.sourceLocation.coordinate.longitude;
    region.center.latitude = self.sourceLocation.coordinate.latitude;
    region.span.longitudeDelta = 0.1;
    region.span.latitudeDelta = 0.1;

    
    //[self.mapView setRegion:region animated:YES]; //change map to point to current location

    [MKMapItem openMapsWithItems:@[mapItem1, mapItem2] launchOptions:nil];

    self.routeFromLocation.hidden = NO;
    
}
@end
