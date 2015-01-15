#import <Foundation/Foundation.h>
#import "ListsNode.h"

@interface DataNode: NSObject

@property (nonatomic, assign)	long limit;
@property (nonatomic, assign)	long totalCount;
@property (nonatomic, assign)	long page;
@property (nonatomic, assign)	long totalPage;
@property (nonatomic, strong)	ListsNode *listsNode;

+(DataNode *) fromDic: (NSDictionary *)dic;

@end