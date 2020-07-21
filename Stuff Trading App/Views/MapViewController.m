//
//  MapViewController.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 20/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "MapViewController.h"
#import "LocationSearchTable.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

CLLocationManager *locationManager;
UISearchController *searchController;
MKPlacemark *selectedPin;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestLocation];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LocationSearchTable *locationSearchTable = [storyBoard instantiateViewControllerWithIdentifier:@"locationSearchTable"];
    searchController = [[UISearchController alloc] initWithSearchResultsController:locationSearchTable];
    searchController.searchResultsUpdater = locationSearchTable;
    
    UISearchBar *searchBar = searchController.searchBar;
    [searchBar sizeToFit];
    searchBar.placeholder = @"Search for places";
    self.navigationItem.titleView = searchController.searchBar;
    
    searchController.hidesNavigationBarDuringPresentation = NO;
    self.definesPresentationContext = YES;
    
    locationSearchTable.mapView = self.mapView;
    locationSearchTable.delegate = self;
    
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [locationManager requestLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations firstObject];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    [self.mapView setRegion:region animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error with location manager: %@", error.localizedDescription);
}

#pragma mark - Drop Pin Delegate

- (void)dropPinZoomIn:(MKPlacemark *)placemark {
    selectedPin = placemark;
    [self.mapView removeAnnotations:[self.mapView annotations]];
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = placemark.coordinate;
    annotation.title = placemark.name;
    annotation.subtitle = [NSString stringWithFormat:@"%@ %@",
                           (placemark.locality == nil ? @"" : placemark.locality),
                           (placemark.administrativeArea == nil ? @"" : placemark.administrativeArea)];
    [self.mapView addAnnotation:annotation];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(placemark.coordinate, span);
    [self.mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    NSString *pin = @"pin";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pin];
    if(pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pin];
        pinView.enabled = YES;
        pinView.canShowCallout = YES;
        pinView.tintColor = [UIColor orangeColor];
    } else {
        pinView.annotation = annotation;
    }
    
    return pinView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
