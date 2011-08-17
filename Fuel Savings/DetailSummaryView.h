//
//  DetailSummaryView.h
//  Fuel Savings
//
//  Created by Axel Rivera on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DETAIL_SUMMARY_VIEW_TAG 1

@interface DetailSummaryView : UIView {
	NSMutableArray *detailViews_;
}

@property (nonatomic, retain) UIColor *oddColor;
@property (nonatomic, retain) UIColor *evenColor;

@property (nonatomic, retain, readonly) NSArray *details;

@property (nonatomic, retain, readonly) UIImageView *imageView;
@property (nonatomic, retain, readonly) UILabel *titleLabel;
@property (nonatomic, retain, readonly) NSArray *detailViews;

- (id)initWithDetails:(NSArray *)details;

@end
