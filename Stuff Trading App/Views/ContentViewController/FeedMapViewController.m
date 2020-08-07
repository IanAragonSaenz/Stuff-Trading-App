//
//  FeedMapViewController.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 27/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "FeedMapViewController.h"
#import <Parse/Parse.h>
#import "PostAnnotation.h"
#import "PostPinAnnotationView.h"
#import "DetailPostViewController.h"
#import "Constants.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "User.h"
#import "SceneDelegate.h"

@interface FeedMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) NSArray *annotations;
@property (strong, nonatomic) PostPinAnnotationView *selectedPin;

@end

@implementation FeedMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.annotations = [NSArray array];
    
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestLocation];
    [self fetchPosts];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navItem.title = @"Feed Map";
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navItem.leftBarButtonItem = logoutButton;
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    self.navItem.rightBarButtonItem = shareButton;
}

#pragma mark - Fetch Posts

- (void)fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([Post class])];
    [query includeKey:kLocationKey];
    [query includeKey:kSectionKey];
    [query includeKey:kAuthorKey];
    PFQuery *location = [PFQuery queryWithClassName:NSStringFromClass([Location class])];
    [location whereKey:kCoordinateKey nearGeoPoint:[PFGeoPoint geoPointWithLocation:self.locationManager.location] withinKilometers:100.0];
    [query whereKey:kLocationKey matchesQuery:location];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if(error) {
            NSLog(@"error getting post locations: %@", error.localizedDescription);
        } else {
            self.posts = posts;
            for(Post *post in posts) {
                [self dropPinIn:post];
            }
        }
    }];
}

#pragma mark - Set Annotations

- (void)dropPinIn:(Post *)post {
    PostAnnotation *annotation = [PostAnnotation setAnnotation:post];
    [self.mapView addAnnotation:annotation];
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager requestLocation];
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

#pragma mark - MKMapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(PostAnnotation *)annotation {
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kPin];
    if(pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPin];
        pinView.enabled = YES;
        pinView.canShowCallout = YES;
        pinView.tintColor = [UIColor orangeColor];
    } else {
        pinView.annotation = annotation;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
    [annotation.post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(error) {
            NSLog(@"error loading image data: %@", error.localizedDescription);
        } else {
            [button setBackgroundImage:[UIImage imageWithData:data]
                              forState:UIControlStateNormal];
        }
    }];
    [button addTarget:self action:@selector(getPost) forControlEvents:UIControlEventTouchUpInside];
    pinView.leftCalloutAccessoryView = button;
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(PostPinAnnotationView *)view {
    self.selectedPin = view;
}

#pragma mark - Get Selected Post

- (void)getPost {
    [self performSegueWithIdentifier:@"detailSegue" sender:self.selectedPin.annotation.post];
}

#pragma mark - Logout

- (void)logout {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginView = [storyBoard instantiateViewControllerWithIdentifier:@"loginView"];
    sceneDelegate.window.rootViewController = loginView;
    
    if([FBSDKAccessToken currentAccessToken]) {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
    }
    [User logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        //needs to be open so that current user sets to nil
    }];
}

- (void)share {
    [self performSegueWithIdentifier:@"composePostSegue" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"detailSegue"]){
        DetailPostViewController *detailPostView = [segue destinationViewController];
        detailPostView.post = sender;
    }
}

@end
