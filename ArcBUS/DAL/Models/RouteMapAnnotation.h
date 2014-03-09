//
//  RouteMapAnnotation.h
//  ArcusMBTA
//
//  Created by David C. Thor on 1/21/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RouteMapAnnotation : NSObject <MKAnnotation> {
    
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
    
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d;
- (id)initWithCoordinate:(CLLocationCoordinate2D)c2d;
- (void)setTitle:(NSString *)ttl;
- (void)setSubtitle:(NSString *)subttl;

@end
