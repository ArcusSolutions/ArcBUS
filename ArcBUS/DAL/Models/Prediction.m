//
//  Prediction.m
//  ArcusMBTA
//
//  Created by David C. Thor on 1/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "Prediction.h"

@implementation Prediction

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    self.epochTime = [[data objectForKey:@"epochTime"] integerValue];
    self.seconds = [[data objectForKey:@"seconds"] integerValue];
    self.minutes = [[data objectForKey:@"minutes"] integerValue];
    self.isDeparture = [[data objectForKey:@"isDeparture"] boolValue];
    self.affectedByLayover = [[data objectForKey:@"affectedByLayover"] boolValue];
    self.dirTag = [data objectForKey:@"dirTag"];
    self.vehicle = [data objectForKey:@"vehicle"];
    self.block = [data objectForKey:@"block"];
    self.tripTag = [data objectForKey:@"tripTag"];
    
    return self;
}

@end
