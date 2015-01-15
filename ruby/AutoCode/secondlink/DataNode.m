#import "DataNode.h"

@implementation DataNode

+(DataNode *) fromDic: (NSDictionary *)dic
{
	DataNode *node = [[DataNode alloc] init];

	node.limit = [[dic objectForKey: @"limit"] longValue];
	node.totalCount = [[dic objectForKey: @"totalCount"] longValue];
	node.page = [[dic objectForKey: @"page"] longValue];
	node.totalPage = [[dic objectForKey: @"totalPage"] longValue];
	node.lists = [dic objectForKey: @"lists"];

	return node;
}

@end