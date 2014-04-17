

#import "CommonVariable.h"

static CommonVariable *commVari = nil;

@implementation CommonVariable


- (id)init{
    if (self = [super init]) {

    }
    return self;
}



+ (id)shareCommonVariable{
    if (!commVari) {
        commVari = [[CommonVariable alloc] init];
    }
    return commVari;
}
@end
