//
//  NSDictionary+Derp.m
//  DerpKit
//
//  Created by Steve Streza on 10/26/12.
//  Copyright (c) 2012 Mustacheware. All rights reserved.
//

#import "NSDictionary+Derp.h"

@implementation NSDictionary (Derp)

-(NSDictionary *)derp_dictionaryByMappingWithHandler:(id (^)(id object, id key, BOOL *stop))handler{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:self.count];
	
	[self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		id object = handler(obj, key, stop);
		if(object){
			[dictionary setObject:object forKey:key];
		}
	}];
	
	return [dictionary copy];
}

-(NSDictionary *)derp_subdictionaryByFilteringWithHandler:(BOOL (^)(id object, id key, BOOL *stop))handler{
	NSMutableDictionary *dictionary = [self mutableCopy];
	
	[self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		BOOL success = handler(obj, key, stop);
		if(!success){
			[dictionary removeObjectForKey:key];
		}
	}];
	
	return [dictionary copy];
}

@end
