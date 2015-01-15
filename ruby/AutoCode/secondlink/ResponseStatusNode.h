#import <Foundation/Foundation.h>
#import "DataNode.h"

@interface ResponseStatusNode: NSObject

@property (nonatomic, strong)	NSString* msg;
@property (nonatomic, assign)	BOOL success;
@property (nonatomic, assign)	long code;
@property (nonatomic, strong)	DataNode *dataNode;

+(ResponseStatusNode *) fromDic: (NSDictionary *)dic;

@end