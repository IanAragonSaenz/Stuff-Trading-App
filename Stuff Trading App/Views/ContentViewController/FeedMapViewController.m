//
//  FeedMapViewController.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 27/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "FeedMapViewController.h"
@import MapKit;

@interface FeedMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation FeedMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    self.navItem.title = @"Feed Map";
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
