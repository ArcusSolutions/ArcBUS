//
//  SimpleRoute.m
//  ArcusMBTA
//
//  Created by David C. Thor on 1/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "SimpleRoute.h"

@implementation SimpleRoute

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    self.tag = [data objectForKey:@"tag"];
    self.title = [data objectForKey:@"title"];
    
    return self;
}

@end
