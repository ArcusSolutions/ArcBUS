//
//  ResponseParser.m
//  ArcusMBTA
//
//  Created by David C. Thor on 1/15/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "ResponseParser.h"

@implementation ResponseParser

- (Response *)parseResponseFromJSON:(NSString *)json
{
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization
                                JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                options:0
                                error:&error];
    if(error != nil)
        return nil;
    
    Response *response = [[Response alloc] init];
    response.body = jsonObject;
    
    return response;
}

@end
