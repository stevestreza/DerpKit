//
//  NSDictionary+Derp.h
//  DerpKit
//
//  Created by Steve Streza on 10/26/12.
//  Copyright (c) 2012 Mustacheware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Derp)

-(NSDictionary *)derp_dictionaryByMappingWithHandler:(id (^)(id object, id key, BOOL *stop))handler;
-(NSDictionary *)derp_subdictionaryByFilteringWithHandler:(BOOL (^)(id object, id key, BOOL *stop))handler;

@end
