//
//  JBNews.m
//  CoreTextDemo
//
//  Created by Terra MacBook on 16/7/27.
//  Copyright © 2016年 Jianbing Zhou. All rights reserved.
//

#import "JBNews.h"
#import "JBAutolayoutTableViewCell.h"
#import "JBTableViewCell.h"
static NSString *cellId = @"cell";
static NSString *jbcellId = @"jbcell";
@implementation JBNews

//传统的KVC字典转模型  这里我们用Runtime写了一个NSObject的类别 起到简单的字典转模型功能

//+ (JBNews *)getJBNewsWithDictionary:(NSDictionary *)dictionary {
//    return [[self alloc] initJBNewsWithDictionary:dictionary];
//}
//
//- (instancetype)initJBNewsWithDictionary:(NSDictionary *)dictionary {
//    if (self = [super init]) {
//        [self setValuesForKeysWithDictionary:dictionary];
//        
//    }
//    return self;
//}
//
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    if ([key isEqualToString:@"id"]) {
//        self.jbNewsId = value;
//    }
//}

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        /*
        JBAutolayoutTableViewCell *cell = [[JBAutolayoutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        //JBAutolayoutTableViewCell *cell = [[JBAutolayoutTableViewCell alloc] init];
        _cellHeight = [cell cellHeightWithNews:self];
         */
        JBTableViewCell *cell = [[JBTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:jbcellId];
        _cellHeight = [cell cellHeightWithModel:self];
    }
    return _cellHeight + 40;
}

@end
