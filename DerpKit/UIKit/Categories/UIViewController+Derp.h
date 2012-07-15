//
//  UIViewController+Derp.h
//  DerpKit
//
//  Created by Steve Streza on 7/15/12.
//  Copyright (c) 2012 Mustacheware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Derp)

-(BOOL)derp_isViewVisible;
-(void)derp_performIfVisible:(dispatch_block_t)handler;

-(void)derp_addKeyboardViewHandlers;
-(void)derp_removeKeyboardViewHandlers;

@end
