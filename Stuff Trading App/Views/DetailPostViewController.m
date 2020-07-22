//
//  DetailPostViewController.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 14/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "DetailPostViewController.h"
#import "UserViewController.h"
@import MapKit;

static NSString *const pin = @"pin";

@interface DetailPostViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDescription;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation DetailPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    
    //setting post info
    self.username.text = self.post.author.username;
    self.titleLabel.text = self.post.title;
    self.postDescription.text = self.post.desc;
    [self.post.author.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(!error)
            self.userImage.image = [UIImage imageWithData:data];
    }];
    [self.post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(!error)
            self.postImage.image = [UIImage imageWithData:data];
    }];
    
    //adding tap gesture to user pic
    UITapGestureRecognizer *tapUser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(segueUser)];
    [self.userImage addGestureRecognizer:tapUser];
    [self.userImage setUserInteractionEnabled:YES];
    
    //adding pin of post
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = CLLocationCoordinate2DMake(self.post.location.coordinate.latitude, self.post.location.coordinate.longitude);
    annotation.title = self.post.location.locationName;
    annotation.subtitle = self.post.location.locationSubtitle;
    [self.mapView addAnnotation:annotation];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(annotation.coordinate, span);
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - MKMapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pin];
    if(pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pin];
        pinView.enabled = YES;
        pinView.canShowCallout = YES;
        pinView.tintColor = [UIColor orangeColor];
    } else {
        pinView.annotation = annotation;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
    [button setBackgroundImage:[UIImage imageNamed:@"icon-car"]
                      forState:UIControlStateNormal];
    [button addTarget:self action:@selector(getDirections) forControlEvents:UIControlEventTouchUpInside];
    pinView.leftCalloutAccessoryView = button;
    
    return pinView;
}

#pragma mark - Directions

- (void)getDirections {
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.post.location.coordinate.latitude,
                                                                                                self.post.location.coordinate.longitude)];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
}

#pragma mark - Segue to User

- (void)segueUser{
    [self performSegueWithIdentifier:@"userSegue" sender:self.post.author];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"userSegue"]) {
         UserViewController *userView = [segue destinationViewController];
         userView.user = sender;
     }
}


@end
