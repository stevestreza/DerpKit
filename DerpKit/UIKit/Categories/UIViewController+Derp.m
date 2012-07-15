//
//  UIViewController+Derp.m
//  DerpKit
//
//  Created by Steve Streza on 7/15/12.
//  Copyright (c) 2012 Mustacheware. All rights reserved.
//

#import "UIViewController+Derp.h"

@implementation UIViewController (Derp)

-(BOOL)derp_isViewVisible{
	return self.isViewLoaded && self.view.window;
}

-(void)derp_performIfVisible:(dispatch_block_t)handler{
	if([self derp_isViewVisible] && handler){
		handler();
	}
}

@end
