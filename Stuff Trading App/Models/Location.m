//
//  Location.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 22/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "Location.h"

@implementation Location

@dynamic coordinate;
@dynamic locationName;
@dynamic locationSubtitle;

+ (nonnull NSString *)parseClassName {
    return @"Location";
}

+ (Location *)makeLocation:(MKPlacemark *)placemark {
    Location *location = [Location new];
    location.coordinate = [PFGeoPoint geoPointWithLocation:placemark.location];
    location.locationName = placemark.name;
    location.locationSubtitle = [NSString stringWithFormat:@"%@ %@",
                             (placemark.locality == nil ? @"" : placemark.locality),
                             (placemark.administrativeArea == nil ? @"" : placemark.administrativeArea)];
    [location saveInBackground];
    return location;
}
@end
