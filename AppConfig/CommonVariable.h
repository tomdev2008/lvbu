
#import <Foundation/Foundation.h>
#import "ModelCollection.h"


@interface CommonVariable : NSObject


@property(nonatomic, retain)User *curUser;          //当前用户

//是否正在运动， 打开侣步界面时用到，如果正在运动，则直接打开运动界面。
@property(nonatomic, assign)BOOL isRunning;

//当前陪跑关系
@property(nonatomic, retain)PartnerRelation *partRelation;

+ (id)shareCommonVariable;

@end
