//
//  UIViewController+iAd.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+iAd.h"
#import "Fuel_SavingsAppDelegate.h"

@implementation UIViewController (UIViewController_iAd)

- (void)layoutContentViewForCurrentOrientation:(UIView *)contentView animated:(BOOL)animated
{
	CGFloat animationDuration = animated ? 0.2f : 0.0f;
	// by default content consumes the entire view area
	CGRect contentFrame = self.view.bounds;
	// the banner still needs to be adjusted further, but this is a reasonable starting point
	// the y value will need to be adjusted by the banner height to get the final position
	CGPoint bannerOrigin = CGPointMake(CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
	CGFloat bannerHeight = 0.0f;
	
	ADBannerView *adBanner = SharedAdBannerView;
	
	// First, setup the banner's content size and adjustment based on the current orientation
	if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
		adBanner.currentContentSizeIdentifier = (&ADBannerContentSizeIdentifierLandscape != nil) ? ADBannerContentSizeIdentifierLandscape : ADBannerContentSizeIdentifier480x32;
	} else {
		adBanner.currentContentSizeIdentifier = (&ADBannerContentSizeIdentifierPortrait != nil) ? ADBannerContentSizeIdentifierPortrait : ADBannerContentSizeIdentifier320x50;
	}
	
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
	
	// And finally animate the changes, running layout for the content view if required.
	[UIView animateWithDuration:animationDuration
					 animations:^{
						 contentView.frame = contentFrame;
						 [contentView layoutIfNeeded];
						 adBanner.frame = CGRectMake(bannerOrigin.x, bannerOrigin.y, adBanner.frame.size.width, adBanner.frame.size.height);
					 }];
}

@end
