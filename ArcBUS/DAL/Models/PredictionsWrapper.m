//
//  PredictionsWrapper.m
//  ArcusMBTA
//
//  Created by David C. Thor on 1/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "PredictionsWrapper.h"

@implementation PredictionsWrapper

- (id)initWithData:(NSDictionary *)data;
{
    self = [super init];
    
    self.agencyTitle = [data objectForKey:@"agencyTitle"];
    self.routeTitle = [data objectForKey:@"routeTitle"];
    self.routeTag = [data objectForKey:@"routeTag"];
    self.stopTitle = [data objectForKey:@"stopTitle"];
    self.stopTag = [data objectForKey:@"stopTag"];
    self.dirTitleBecauseNoPredictions = [data objectForKey:@"dirTitleBecauseNoPredictions"];
    
    NSMutableArray *directions = [[NSMutableArray alloc] init];
    NSObject *directionObj = [data objectForKey:@"direction"];
    if ([directionObj isKindOfClass:[NSDictionary class]]) {
        PredictionsDirection *predDirection = [[PredictionsDirection alloc] initWithData:[data objectForKey:@"direction"]];
        [directions addObject:predDirection];
    } else if ([directionObj isKindOfClass:[NSArray class]]) {
        for (NSDictionary *directionDict in [data objectForKey:@"direction"]) {
            PredictionsDirection *predDirection = [[PredictionsDirection alloc] initWithData:directionDict];
            [directions addObject:predDirection];
        }
    }
    
    self.directions = [NSArray arrayWithArray:directions];
    
    return self;
}


- (PredictionsDirection *)getDirectionForTitle:(NSString *)title
{
    for (PredictionsDirection *direction in self.directions) {
        if ([direction.title isEqualToString:title]) {
            return direction;
        }
    }
    
    return nil;
}

@end
