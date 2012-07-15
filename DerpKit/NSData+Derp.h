//
//  NSData+Derp.h
//  DerpKit
//
//  Created by Steve Streza on 7/15/12.
//  Copyright (c) 2012 Mustacheware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Derp)

-(NSString *)derp_stringByBase64EncodingData;
-(NSString *)derp_stringByBase64DecodingData;

-(NSString *)derp_UTF8String;

@end
