//
//  LocationSearchTableViewController.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 20/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;
#import "MapViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocationSearchTableViewController : UITableViewController <UISearchResultsUpdating>

@property  (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) id<HandleMapSearch> handleMapSearchDelegate;

@end

NS_ASSUME_NONNULL_END
