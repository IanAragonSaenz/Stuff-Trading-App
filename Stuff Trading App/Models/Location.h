//
//  Location.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 22/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import <Parse/Parse.h>
@import MapKit;

NS_ASSUME_NONNULL_BEGIN

@interface Location : PFObject <PFSubclassing>

@property (strong, nonatomic) PFGeoPoint *coordinate;
@property (strong, nonatomic) NSString *locationName;
@property (strong, nonatomic) NSString *locationSubtitle;

+ (Location *)makeLocation:(MKPlacemark *)placemark;

@end

NS_ASSUME_NONNULL_END
