//
//  WebRepository.m
//  Prototype
//
//  Created by Michael Muesch on 1/14/14.
//  Copyright (c) 2014 ArcusSolutions. All rights reserved.
//

#import "WebRepository.h"

@implementation WebRepository

-(id) init
{
    self = [super init];
    self.databaseRepository = [[DatabaseRepository alloc]init];
    [self.databaseRepository executeQuery:@"CREATE TABLE IF NOT EXISTS cache (Url Text, Data Text)"];
    return self;
}

-(NSString *)sanitizeURL:(NSString *)url{
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(NSString*) getWithUrl:(NSString *)url
{
    url = [self sanitizeURL:url];
    
    NSString *results = [self.databaseRepository getColumnIndex:0 fromQuery:[NSString stringWithFormat:@"SELECT Data FROM cache WHERE Url='%@'",url]];
    if(results != nil)
        return results;
    
    NSURL *uri = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:uri cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *stringData = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
    [self.databaseRepository executeQuery:[NSString stringWithFormat:@"INSERT INTO cache('Url','Data') VALUES('%@',%@)",url,[self.databaseRepository escape:stringData]]];
    
    return stringData;
}

-(NSString*) postWithUrl:(NSString *)url andBody:(NSString *)body
{
    url = [self sanitizeURL:url];
    NSData* bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *uri = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:uri cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:bodyData];
    
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}

-(NSString*) putWithUrl:(NSString *)url andBody:(NSString *)body
{
    url = [self sanitizeURL:url];
    NSData* bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *uri = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:uri cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:bodyData];
    
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}

-(NSString*) deleteWithUrl:(NSString *)url andBody:(NSString *)body
{
    url = [self sanitizeURL:url];
    NSData* bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *uri = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:uri cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:bodyData];
    
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}

@end