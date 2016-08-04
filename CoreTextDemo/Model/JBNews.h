//
//  JBNews.h
//  CoreTextDemo
//
//  Created by Terra MacBook on 16/7/27.
//  Copyright © 2016年 Jianbing Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JBNews : NSObject
//@property (nonatomic, retain) NSString *jbNewsId;
@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *descr;
@property (nonatomic, retain) NSString *imgurl;

@property (nonatomic, assign) CGFloat cellHeight;


//+ (JBNews *)getJBNewsWithDictionary:(NSDictionary *)dictionary;
//
//- (instancetype)initJBNewsWithDictionary:(NSDictionary *)dictionary;
@end
