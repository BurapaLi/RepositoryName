//
//  NSObject+JBKeyValue.h
//  JBExtension
//
//  Created by Terra MacBook on 16/7/30.
//  Copyright © 2016年 Jianbing Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JBKeyValue)
//字典转模型
+ (instancetype)objectWithKeyValues:(id)keyValues;
@end
