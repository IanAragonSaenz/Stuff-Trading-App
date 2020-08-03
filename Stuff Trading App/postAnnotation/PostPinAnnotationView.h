//
//  PostPinAnnotationView.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 27/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "PostAnnotation.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostPinAnnotationView : MKPinAnnotationView

@property (strong, nonatomic) PostAnnotation *annotation;

@end

NS_ASSUME_NONNULL_END
