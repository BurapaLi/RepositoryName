//
//  News+CoreDataProperties.h
//  CoreTextDemo
//
//  Created by Terra MacBook on 16/7/27.
//  Copyright © 2016年 Jianbing Zhou. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "News.h"

NS_ASSUME_NONNULL_BEGIN

@interface News (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *descr;
@property (nullable, nonatomic, retain) NSString *imgurl;

@end

NS_ASSUME_NONNULL_END
