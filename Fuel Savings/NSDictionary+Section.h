//
//  NSDictionary+Section.h
//  Fuel Savings
//
//  Created by Axel Rivera on 8/8/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const dictionaryKey;
extern NSString * const dictionaryTextKey;
extern NSString * const dictionaryDetailKey;
extern NSString * const dictionaryButtonKey;

@interface NSDictionary (NSDictionary_Section)

+ (NSDictionary *)textDictionaryWithKey:(NSString *)key text:(NSString *)text detail:(NSString *)detail;
+ (NSDictionary *)buttonDictionaryWithKey:(NSString *)key text:(NSString *)text;

@end
