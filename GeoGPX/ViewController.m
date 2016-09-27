//
//  ViewController.m
//  HoyaGeo
//
//  Created by Pomme on 6/28/16.
//  Copyright © 2016 Yuanjie Xie. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UISwitch *switchActivate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkStatusButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) BOOL mapIsMoving;
@property (strong, nonatomic) MKPointAnnotation *currentAnnotation;

@property (weak, nonatomic) IBOutlet UILabel *latitudeText;
@property (weak, nonatomic) IBOutlet UILabel *longitudeText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Turn off the User Interface until permission is obtained.
    self.switchActivate.enabled = NO;
    self.checkStatusButton.enabled = NO;
    
    self.mapIsMoving = NO;
    self.longitudeText.text = @"longitude";
    self.latitudeText.text = @"latitude";
    
    // Set up the location Manager
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        self.locationManager.allowsBackgroundLocationUpdates = YES;
        self.locationManager.pausesLocationUpdatesAutomatically = YES;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 5; // meters
        
    // Zoom the map very close
        CLLocationCoordinate2D noLocation;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500); // 500 by 500
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustedRegion animated:YES];
    
    // Create an annotation for the user's location
    [self addCurrentAnnotation];
}

-(void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    CLAuthorizationStatus currentStatus = [CLLocationManager authorizationStatus];
    if ((currentStatus == kCLAuthorizationStatusAuthorizedWhenInUse) || (currentStatus == kCLAuthorizationStatusAuthorizedAlways)) {
        self.switchActivate.enabled = YES;
    }
}

-(void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    self.mapIsMoving = YES;
}

-(void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    self.mapIsMoving = NO;
}


- (IBAction)switchClicked:(id)sender {
    if (self.switchActivate.isOn) {
        self.mapView.showsUserLocation = YES;
        [self.locationManager startUpdatingLocation];
        self.checkStatusButton.enabled = YES;
    }
    else {
        self.checkStatusButton.enabled = YES;
        [self.locationManager stopUpdatingLocation];
        self.mapView.showsUserLocation = NO;
    }
}


- (void) addCurrentAnnotation {
    self.currentAnnotation = [[MKPointAnnotation alloc]init];
    self.currentAnnotation.coordinate = CLLocationCoordinate2DMake(0.0, 0.0);
    self.currentAnnotation.title = @"My Location";
    
}


- (void) centerMap:(MKPointAnnotation *)centerPoint {
    [self.mapView setCenterCoordinate:centerPoint.coordinate animated:YES];
}


#pragma mark - callback functions of location

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.currentAnnotation.coordinate = locations.lastObject.coordinate;
    if (self.mapIsMoving == NO) {
        [self centerMap:self.currentAnnotation];
    }
}

- (IBAction)checkStatusClicked:(id)sender {
    //[self.locationManager requestStateForRegion:self.geoRegion];
    self.latitudeText.text = [NSString stringWithFormat:@"%.3f", _currentAnnotation.coordinate.latitude];
    self.longitudeText.text = [NSString stringWithFormat: @"%.3f", _currentAnnotation.coordinate.longitude];
}


- (IBAction)latitudeItem:(id)sender {
}
@end
