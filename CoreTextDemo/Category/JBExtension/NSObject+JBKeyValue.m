//
//  NSObject+JBKeyValue.m
//  JBExtension
//
//  Created by Terra MacBook on 16/7/30.
//  Copyright © 2016年 Jianbing Zhou. All rights reserved.
//

#import "NSObject+JBKeyValue.h"
#import <objc/runtime.h>

@implementation NSObject (JBKeyValue)
//字典转模型
+ (instancetype)objectWithKeyValues:(id)keyValues {
    NSObject *object = [[self alloc] init];
    [object setKeyValues:keyValues];
    return object;
}

- (void)setKeyValues:(NSDictionary<NSString *, id> *)dictionary {
    Class c = self.class;
    while (c &&c != [NSObject class]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(c, &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
            // 成员变量名转为属性名（去掉下划线 _ ）
            key = [key substringFromIndex:1];
            // 取出字典的值
            id value = dictionary[key];
            
            // 如果模型属性数量大于字典键值对数理，模型属性会被赋值为nil而报错
            if (value == nil) continue;
            
            // 获得成员变量的类型
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            
            // 如果属性是对象类型
            NSRange range = [type rangeOfString:@"@"];
            if (range.location != NSNotFound) {
                // 那么截取对象的名字（比如@"Dog"，截取为Dog）
                type = [type substringWithRange:NSMakeRange(2, type.length - 3)];
                // 排除系统的对象类型
                if (![type hasPrefix:@"NS"]) {
                    // 将对象名转换为对象的类型，将新的对象字典转模型（递归）
                    Class class = NSClassFromString(type);
                    value = [class objectWithKeyValues:value];
                }
            }
            // 将字典中的值设置到模型上
            [self setValue:value forKeyPath:key];
        }
        free(ivars);
        c = [c superclass];
    }
}



@end
