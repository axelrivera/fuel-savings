//
//  RLBannerViewObject.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RLBannerViewObject.h"

@interface RLBannerViewObject (Private)

- (void)setAdBannerView:(ADBannerView *)adBannerView;

@end

@implementation RLBannerViewObject

@synthesize adBannerViewIsVisible = adBannerViewIsVisible_;
@synthesize adBannerView = adBannerView_;

+ (id)bannerInPortrait:(BOOL)portrait andLandscape:(BOOL)landscape
{
	NSAssert(portrait == YES || landscape == YES, @"At least one mode must be YES");
	
	RLBannerViewObject *banner = [[[RLBannerViewObject alloc] init] autorelease];
	
	Class classAdBannerView = NSClassFromString(@"ADBannerView");
	if (classAdBannerView != nil) {
		
		ADBannerView *adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
		
		[banner setAdBannerView:adView];
		[adView release];
		
		NSMutableSet *identifiers = [[NSMutableSet alloc] initWithCapacity:0];
		
		if (portrait) {
			[identifiers addObject:ADBannerContentSizeIdentifierPortrait];
		}
		
		if (landscape) {
			[identifiers addObject:ADBannerContentSizeIdentifierLandscape];
		}
		
		[banner.adBannerView setRequiredContentSizeIdentifiers:identifiers];
		
		[identifiers release];
		
		if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
			[banner.adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierLandscape];
		} else {
			[banner.adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];            
		}
		
		
		
		[banner.adBannerView setFrame:CGRectOffset([banner.adBannerView frame], 0, -[banner getBannerHeight])];
	}
	return banner;
}

+ (id)bannerInPortraitOrientation
{
	return [[self class] bannerInPortrait:YES andLandscape:NO];
}

+ (id)bannerInLandscapeOrientation
{
	return [[self class] bannerInPortrait:NO andLandscape:YES];
}

- (id)init
{
	self = [super init];
	if (self) {
		self.adBannerViewIsVisible = NO;
		adBannerView_ = nil;
	}
    return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (void)setAdBannerView:(ADBannerView *)adBannerView
{
	[adBannerView_ autorelease];
	adBannerView_ = [[adBannerView retain] autorelease];
}

- (NSInteger)getBannerHeight:(UIDeviceOrientation)orientation
{
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        return 32;
    }
	return 50;
}

- (NSInteger)getBannerHeight {
    return [self getBannerHeight:[UIDevice currentDevice].orientation];
}

- (void)fixupAdView:(UIDeviceOrientation)toDeviceOrientation contentView:(UIView *)contentView {
    if (adBannerView_ != nil) {        
        if (UIInterfaceOrientationIsLandscape(toDeviceOrientation)) {
            [adBannerView_ setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierLandscape];
        } else {
            [adBannerView_ setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
        }
		
        [UIView beginAnimations:@"fixupViews" context:nil];
        if (adBannerViewIsVisible_) {
            CGRect adBannerViewFrame = adBannerView_.frame;
			
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = 0;
            
			[adBannerView_ setFrame:adBannerViewFrame];
            
			CGRect contentViewFrame = contentView.frame;
            
			contentViewFrame.origin.y = [self getBannerHeight:toDeviceOrientation];
            contentViewFrame.size.height = adBannerView_.superview.frame.size.height - [self getBannerHeight:toDeviceOrientation];
            contentView.frame = contentViewFrame;
        } else {
            CGRect adBannerViewFrame = adBannerView_.frame;
            
			adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = -[self getBannerHeight:toDeviceOrientation];
          
			adBannerView_.frame = adBannerViewFrame;
            
			CGRect contentViewFrame = contentView.frame;
			
            contentViewFrame.origin.y = 0;
            contentViewFrame.size.height = adBannerView_.superview.frame.size.height;
			
            contentView.frame = contentViewFrame;            
        }
        [UIView commitAnimations];
    }   
}

@end
