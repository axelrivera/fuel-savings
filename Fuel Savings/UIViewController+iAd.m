//
//  UIViewController+iAd.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/25/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "UIViewController+iAd.h"
#import "Fuel_SavingsAppDelegate.h"

@interface UIViewController()

- (void)layoutContentFrame:(CGRect)contentFrame bannerFrame:(CGRect)bannerFrame animated:(BOOL)animated;
- (NSString *)currentAdContentSizeIdentifier;

@end

@implementation UIViewController (UIViewController_iAd)

- (void)layoutCurrentOrientation:(BOOL)animated
{
	ADBannerView *adBanner = SharedAdBannerView;
	
	UIView *currentView = self.view;
	UIView *currentAdParentView = adBanner.superview;
	
	if (currentAdParentView == nil) {
		[self.view addSubview:adBanner];
	} else {
		if (currentView != currentAdParentView) {
			[adBanner removeFromSuperview];
			[self.view addSubview:adBanner];
		}
	}
	
	// by default content consumes the entire view area
	CGRect contentFrame = self.view.bounds;
	// the banner still needs to be adjusted further, but this is a reasonable starting point
	// the y value will need to be adjusted by the banner height to get the final position
	CGPoint bannerOrigin = CGPointMake(CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
	CGFloat bannerHeight = 0.0f;
	
	adBanner.currentContentSizeIdentifier = [self currentAdContentSizeIdentifier];
	
	bannerHeight = adBanner.bounds.size.height;
	
	// Depending on if the banner has been loaded, we adjust the content frame and banner location
	// to accomodate the ad being on or off screen.
	// This layout is for an ad at the bottom of the view.
	if (adBanner.bannerLoaded) {
		contentFrame.size.height -= bannerHeight;
		bannerOrigin.y -= bannerHeight;
		adBanner.hidden = NO;
	} else {
		bannerOrigin.y += bannerHeight;
	}
	
	CGRect bannerFrame = CGRectMake(bannerOrigin.x,
									bannerOrigin.y,
									adBanner.frame.size.width,
									adBanner.frame.size.height);
	
	[self layoutContentFrame:contentFrame bannerFrame:bannerFrame animated:animated];
}

- (void)hideBannerView:(BOOL)animated
{
	// by default content consumes the entire view area
	CGRect contentFrame = self.view.bounds;
	// the banner still needs to be adjusted further, but this is a reasonable starting point
	// the y value will need to be adjusted by the banner height to get the final position
	CGPoint bannerOrigin = CGPointMake(CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
	CGFloat bannerHeight = 0.0f;
	
	ADBannerView *adBanner = SharedAdBannerView;
	
	adBanner.currentContentSizeIdentifier = [self currentAdContentSizeIdentifier];
	
	bannerHeight = adBanner.bounds.size.height;
	bannerOrigin.y += bannerHeight;
	
	CGRect bannerFrame = CGRectMake(bannerOrigin.x,
									bannerOrigin.y,
									adBanner.frame.size.width,
									adBanner.frame.size.height);
	
	[self layoutContentFrame:contentFrame bannerFrame:bannerFrame animated:animated];
	[adBanner removeFromSuperview];
	adBanner.delegate = nil;
}

- (NSString *)currentAdContentSizeIdentifier
{
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
		return (&ADBannerContentSizeIdentifierLandscape != nil) ? ADBannerContentSizeIdentifierLandscape : ADBannerContentSizeIdentifier480x32;
	}
	return (&ADBannerContentSizeIdentifierPortrait != nil) ? ADBannerContentSizeIdentifierPortrait : ADBannerContentSizeIdentifier320x50;
}

- (void)layoutContentFrame:(CGRect)contentFrame bannerFrame:(CGRect)bannerFrame animated:(BOOL)animated
{
	UIView *contentView = [self.view viewWithTag:kAdContentViewTag];
	NSAssert(contentView != nil, @"ContentView TAG has not been set");
	
	ADBannerView *adBanner = SharedAdBannerView;
	
	CGFloat animationDuration = animated ? 0.2f : 0.0f;
	
	// And finally animate the changes, running layout for the content view if required.
	[UIView animateWithDuration:animationDuration
					 animations:^{
						 contentView.frame = contentFrame;
						 [contentView layoutIfNeeded];
						 adBanner.frame = bannerFrame;
					 }];
}

@end
