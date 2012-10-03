//
//  UIViewController+Derp.m
//  DerpKit
//
//  Created by Steve Streza on 7/15/12.
//  Copyright (c) 2012 Mustacheware. All rights reserved.
//

#import "UIViewController+Derp.h"
#import <objc/runtime.h>

@implementation UIViewController (Derp)

-(BOOL)derp_isViewVisible{
	return self.isViewLoaded && self.view.window;
}

-(void)derp_performIfVisible:(dispatch_block_t)handler{
	if([self derp_isViewVisible] && handler){
		handler();
	}
}

-(void)derp_addKeyboardViewHandlers{
	NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
	id willShow = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:mainQueue usingBlock:^(NSNotification *note) {
		[self derp_performIfVisible:^{
			CGRect keyboardFrame = [self.view convertRect:[(NSValue *)note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]
												 fromView:nil];
			CGRect viewFrame = self.view.frame;
			viewFrame.size.height -= keyboardFrame.size.height;
			
			[UIView beginAnimations:@"UIKeyboard" context:nil];
			
			[UIView setAnimationDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
			[UIView setAnimationCurve:[note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
			
			self.view.frame = viewFrame;
			
			[UIView commitAnimations];
		}];
	}];
	
	id willHide = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:mainQueue usingBlock:^(NSNotification *note) {
		[self derp_performIfVisible:^{
			CGRect keyboardFrame = [(NSValue *)note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
			CGRect viewFrame = self.view.frame;
			viewFrame.size.height += keyboardFrame.size.height;
			
			[UIView beginAnimations:@"UIKeyboard" context:nil];
			
			[UIView setAnimationDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
			[UIView setAnimationCurve:[note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
			
			self.view.frame = viewFrame;
			
			[UIView commitAnimations];
		}];
	}];
	
	objc_setAssociatedObject(self, "derp_willShowKeyboardNotification", willShow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	objc_setAssociatedObject(self, "derp_willHideKeyboardNotification", willHide, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)derp_removeKeyboardViewHandlers{
	id willShow = objc_getAssociatedObject(self, "derp_willShowKeyboardNotification");
	id willHide = objc_getAssociatedObject(self, "derp_willHideKeyboardNotification");
	
	if(willShow){
		[[NSNotificationCenter defaultCenter] removeObserver:willShow];
		objc_setAssociatedObject(self, "derp_willShowKeyboardNotification", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}

	if(willHide){
		[[NSNotificationCenter defaultCenter] removeObserver:willHide];
		objc_setAssociatedObject(self, "derp_willHideKeyboardNotification", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

@end
