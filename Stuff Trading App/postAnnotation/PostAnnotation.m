//
//  PostAnnotation.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 27/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "PostAnnotation.h"

@implementation PostAnnotation

+ (PostAnnotation *)setAnnotation:(Post *)post {
    PostAnnotation *annotation = [PostAnnotation new];
    annotation.coordinate = CLLocationCoordinate2DMake(post.location.coordinate.latitude, post.location.coordinate.longitude);
    annotation.title = post.title;
    annotation.subtitle = post.location.locationName;
    annotation.post = post;
    return annotation;
}

@end
