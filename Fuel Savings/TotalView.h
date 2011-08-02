//
//  TotalView.h
//  Fuel Savings
//
//  Created by Axel Rivera on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	TotalViewTypeSingle,
	TotalViewTypeDouble
} TotalViewType;

@interface TotalView : UIView {
	TotalViewType type_;
}

@property (nonatomic, retain, readonly) UIImageView *imageView;
@property (nonatomic, retain, readonly) UILabel *titleLabel;
@property (nonatomic, retain, readonly) UILabel *text1Label;
@property (nonatomic, retain, readonly) UILabel *text2Label;
@property (nonatomic, retain, readonly) UILabel *detail1Label;
@property (nonatomic, retain, readonly) UILabel *detail2Label;

- (id)initWithFrame:(CGRect)frame type:(TotalViewType)type;

@end
