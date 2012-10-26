//
//  NSObject+Derp.m
//  DerpKit
//
//  Created by Steve Streza on 10/7/12.
//  Copyright (c) 2012 Steve Streza
//  
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

#import "NSObject+Derp.h"
#import <dispatch/dispatch.h>
#import <objc/runtime.h>

@interface DerpKitTrampoline : NSObject
{
    __weak id observee;
    NSString *keyPath;
    DerpKitKVOTask task;
    NSOperationQueue *queue;
    dispatch_once_t cancellationPredicate;
}

- (DerpKitTrampoline *)initObservingObject:(id)obj keyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue task:(DerpKitKVOTask)task;
- (void)cancelObservation;
@end

@implementation DerpKitTrampoline

static NSString *DerpKitTrampolineContext = @"DerpKitTrampolineContext";

- (DerpKitTrampoline *)initObservingObject:(id)obj keyPath:(NSString *)newKeyPath onQueue:(NSOperationQueue *)newQueue task:(DerpKitKVOTask)newTask
{
    if (!(self = [super init])) return nil;
    task = [newTask copy];
    keyPath = [newKeyPath copy];
    queue = newQueue;
    observee = obj;
    cancellationPredicate = 0;
    [observee addObserver:self forKeyPath:keyPath options:0 context:(__bridge void *)(DerpKitTrampolineContext)];
    return self;
}

- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == (__bridge void *)(DerpKitTrampolineContext))
    {
        if (queue)
            [queue addOperationWithBlock:^{ task(object, change); }];
        else
            task(object, change);
    }
}

- (void)cancelObservation
{
    dispatch_once(&cancellationPredicate, ^{
        [observee removeObserver:self forKeyPath:keyPath];
        observee = nil;
    });
}

- (void)dealloc
{
    [self cancelObservation];
}

@end

static NSString *DerpKitMapKey = @"org.andymatuschak.observerMap";
static dispatch_queue_t DerpKitMutationQueue = NULL;

static dispatch_queue_t DerpKitMutationQueueCreatingIfNecessary()
{
    static dispatch_once_t queueCreationPredicate = 0;
    dispatch_once(&queueCreationPredicate, ^{
        DerpKitMutationQueue = dispatch_queue_create("org.andymatuschak.observerMutationQueue", 0);
    });
    return DerpKitMutationQueue;
}

@implementation NSObject (DerpKitKVOObservation)

- (DerpKitKVOToken *)derp_addObserverForKeyPath:(NSString *)keyPath task:(DerpKitKVOTask)task
{
    return [self derp_addObserverForKeyPath:keyPath onQueue:nil task:task];
}

- (DerpKitKVOToken *)derp_addObserverForKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue task:(DerpKitKVOTask)task
{
    DerpKitKVOToken *token = [[NSProcessInfo processInfo] globallyUniqueString];
    dispatch_sync(DerpKitMutationQueueCreatingIfNecessary(), ^{
        NSMutableDictionary *dict = objc_getAssociatedObject(self, (__bridge const void *)(DerpKitMapKey));
        if (!dict)
        {
            dict = [[NSMutableDictionary alloc] init];
            objc_setAssociatedObject(self, (__bridge const void *)(DerpKitMapKey), dict, OBJC_ASSOCIATION_RETAIN);
        }
        DerpKitTrampoline *trampoline = [[DerpKitTrampoline alloc] initObservingObject:self keyPath:keyPath onQueue:queue task:task];
        [dict setObject:trampoline forKey:token];
    });
    return token;
}

- (void)derp_removeObserverWithBlockToken:(DerpKitKVOToken *)token
{
    dispatch_sync(DerpKitMutationQueueCreatingIfNecessary(), ^{
        NSMutableDictionary *observationDictionary = objc_getAssociatedObject(self, (__bridge const void *)(DerpKitMapKey));
        DerpKitTrampoline *trampoline = [observationDictionary objectForKey:token];
        if (!trampoline)
        {
            NSLog(@"[NSObject(DerpKitKVOObservation) removeObserverWithBlockToken]: Ignoring attempt to remove non-existent observer on %@ for token %@.", self, token);
            return;
        }
        [trampoline cancelObservation];
        [observationDictionary removeObjectForKey:token];
        
        // Due to a bug in the obj-c runtime, this dictionary does not get cleaned up on release when running without GC.
        if ([observationDictionary count] == 0)
            objc_setAssociatedObject(self, (__bridge const void *)(DerpKitMapKey), nil, OBJC_ASSOCIATION_RETAIN);
    });
}

@end
