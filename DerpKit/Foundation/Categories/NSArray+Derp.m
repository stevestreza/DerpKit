//
//  NSArray+Derp.m
//  DerpKit
//
//  Created by Steve Streza on 10/25/12.
//  Copyright (c) 2012 Mustacheware. All rights reserved.
//

#import "NSArray+Derp.h"

@implementation NSArray (Derp)

-(NSArray *)derp_arrayByMappingWithHandler:(id (^)(id object, NSUInteger index, BOOL *stop))handler{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
	
	BOOL stop = NO;
	for(NSUInteger index = 0; index < self.count; index++){
		id object = self[index];
		id outObject = handler(object, index, &stop);
		
		if(outObject){
			[array addObject:outObject];
		}
		
		if(stop){
			break;
		}
	}
	return [array copy];
}

-(NSArray *)derp_subarrayByFilteringWithHandler:(BOOL (^)(id object, NSUInteger index, BOOL *stop))handler{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
	
	BOOL stop = NO;
	for(NSUInteger index = 0; index < self.count; index++){
		id object = self[index];
		BOOL success = handler(object, index, &stop);
		if(success){
			[array addObject:object];
		}
		if(stop){
			break;
		}
	}

	return [array copy];
}

@end
