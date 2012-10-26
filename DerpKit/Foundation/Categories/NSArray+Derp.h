//
//  NSArray+Derp.h
//  DerpKit
//
//  Created by Steve Streza on 10/25/12.
//  Copyright (c) 2012 Mustacheware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Derp)

-(NSArray *)derp_arrayByMappingWithHandler:(id (^)(id object, NSUInteger index, BOOL *stop))handler;
-(NSArray *)derp_subarrayByFilteringWithHandler:(BOOL (^)(id object, NSUInteger index, BOOL *stop))handler;

@end
