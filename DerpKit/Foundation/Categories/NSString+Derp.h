//
//  NSString+Derp.h
//  DerpKit
//
//  Created by Steve Streza on 7/15/12.
//  Copyright (c) 2012 Mustacheware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Derp)

-(NSString *)derp_stringByEscapingPercents;
-(NSString *)derp_stringByUnscapingPercents;

-(NSString *)derp_stringByBase64EncodingString;
-(NSString *)derp_stringByBase64DecodingString;
-(NSData   *)derp_dataByBase64DecodingString;

-(NSString *)derp_HMAC_SHA1SignatureWithKey:(NSString *)signingKey;
+(NSString *)derp_randomStringWithLength:(NSUInteger)length;

-(NSData   *)derp_UTF8Data;

@end
