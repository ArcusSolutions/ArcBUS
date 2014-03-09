//
//  XMLUtil.m
//  ArcusMBTA
//
//  Created by David C. Thor on 1/15/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "XMLUtil.h"

@implementation XMLUtil

-(NSDictionary*) parseFromXML:(NSString *)xml
{
    SHXMLParser *parser = [[SHXMLParser alloc] init];
    NSDictionary *resultObject = [parser parseData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    return resultObject;
}


-(NSString*) parseToXML:(NSDictionary *)dictionary
{
    return nil;
}

@end
