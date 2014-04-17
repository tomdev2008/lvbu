
#import <Foundation/Foundation.h>
#import "ModelCollection.h"


@interface CommonVariable : NSObject


@property(nonatomic, retain)User *curUser;


+ (id)shareCommonVariable;

@end
