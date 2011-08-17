//
//  DetailView.h
//  Fuel Savings
//
//  Created by Axel Rivera on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DETAIL_VIEW_HEIGHT 17.0

extern NSString * const kDetailViewTextKey;
extern NSString * const kDetailViewDetailKey;

@interface DetailView : UIView {
	UIFont *textFont_;
	UIFont *detailFont_;
}

@property (nonatomic, retain, readonly) NSString *text;
@property (nonatomic, retain, readonly) NSString *detail;

@property (nonatomic, retain, readonly) UILabel *textLabel;
@property (nonatomic, retain, readonly) UILabel *detailTextLabel;

+ (NSDictionary *)detailDictionaryWithText:(NSString *)text detail:(NSString *)detail;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithText:(NSString *)text detail:(NSString *)detail;

- (void)setText:(NSString *)text detail:(NSString *)detail;

- (NSDictionary *)detailDictionary;

@end
