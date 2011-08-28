//
//  NSDictionary+Section.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+Section.h"
#import "RLCustomButton+Default.h"

NSString * const dictionaryKey = @"DictionaryKey";
NSString * const dictionaryTextKey = @"DictionaryTextKey";
NSString * const dictionaryDetailKey = @"DictionaryDetailKey";
NSString * const dictionaryButtonKey = @"DictionaryButtonKey";

@implementation NSDictionary (NSDictionary_Section)

+ (NSDictionary *)textDictionaryWithKey:(NSString *)key text:(NSString *)text detail:(NSString *)detail
{
	NSDictionary *dictionary = [[[NSDictionary alloc] initWithObjectsAndKeys:
															 key, dictionaryKey,
															 text, dictionaryTextKey,
															 detail, dictionaryDetailKey,
															 nil] autorelease];
	return dictionary;
}

+ (NSDictionary *)buttonDictionaryWithKey:(NSString *)key text:(NSString *)text;
{
	RLCustomButton *button = [[RLCustomButton selectCarButton] retain];
	button.frame = CGRectMake(0.0, 0.0, 110.0, 28.0);
	
	NSDictionary *dictionary = [[[NSDictionary alloc] initWithObjectsAndKeys:
															 key, dictionaryKey,
															 text, dictionaryTextKey,
															 button, dictionaryButtonKey,
															 nil] autorelease];
	[button release];
	
	return dictionary;
}

@end
