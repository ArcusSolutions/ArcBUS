//
//  XMLUtil.h
//  ArcusMBTA
//
//  Created by David C. Thor on 1/15/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SHXMLParser.h>

@interface XMLUtil : NSObject

- (NSDictionary*)parseFromXML:(NSString*)xml;
- (NSString*)parseToXML:(NSDictionary*)dictionary;

@end
