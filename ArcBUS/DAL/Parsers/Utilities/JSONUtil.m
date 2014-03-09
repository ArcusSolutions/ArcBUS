//
//  JSONUtil.m
//  ArcusMBTA
//
//  Created by David C. Thor on 1/15/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "JSONUtil.h"

@implementation JSONUtil

-(NSDictionary*) parseFromJSON:(NSString *)json
{
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization
                                JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                options:0
                                error:&error];
    if(error != nil)
        return nil;
    return jsonObject;
}


-(NSString*) parseToJSON:(NSDictionary *)dictionary
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    if(error != nil)
        return nil;
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
