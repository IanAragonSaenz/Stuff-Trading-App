//
//  FeedMapViewController.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 27/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageViewController.h"
@import MapKit;

NS_ASSUME_NONNULL_BEGIN

@interface FeedMapViewController : BasePageViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@end

NS_ASSUME_NONNULL_END
