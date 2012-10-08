//
//  NSObject+Derp.h
//  DerpKit
//
//  Created by Steve Streza on 10/7/12.
//  Copyright (c) 2012 Mustacheware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString DerpKitKVOToken;
typedef void (^DerpKitKVOTask)(id obj, NSDictionary *change);

@interface NSObject (DerpKitKVOObservation)
- (DerpKitKVOToken *)addObserverForKeyPath:(NSString *)keyPath task:(DerpKitKVOTask)task;
- (DerpKitKVOToken *)addObserverForKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue task:(DerpKitKVOTask)task;
- (void)removeObserverWithBlockToken:(DerpKitKVOToken *)token;
@end

