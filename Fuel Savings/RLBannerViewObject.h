//
//  RLBannerViewObject.h
//  Fuel Savings
//
//  Created by Axel Rivera on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAd/ADBannerView.h"

@interface RLBannerViewObject : NSObject

@property (nonatomic, assign) BOOL adBannerViewIsVisible;
@property (nonatomic, retain, readonly) ADBannerView *adBannerView;

+ (id)bannerInPortrait:(BOOL)portrait andLandscape:(BOOL)landscape;
+ (id)bannerInPortraitOrientation;
+ (id)bannerInLandscapeOrientation;

- (NSInteger)getBannerHeight:(UIDeviceOrientation)orientation;
- (NSInteger)getBannerHeight;

- (void)fixupAdView:(UIDeviceOrientation)toDeviceOrientation contentView:(UIView *)contentView;

@end
