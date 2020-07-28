//
//  MapViewController.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 20/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

NS_ASSUME_NONNULL_BEGIN

@protocol HandleMapSearch <NSObject>

- (void)dropPinZoomIn:(MKPlacemark *)placemark;

@end

@protocol HandlePin <NSObject>

- (void)setLocation:(MKPlacemark *)placemark;

@end

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, HandleMapSearch>

@property (strong, nonatomic) id<HandlePin> handlePin;

@end

NS_ASSUME_NONNULL_END
