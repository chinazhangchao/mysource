#import "ResponseStatusNode.h"

@implementation ResponseStatusNode

+(ResponseStatusNode *) fromDic: (NSDictionary *)dic
{
	ResponseStatusNode *node = [[ResponseStatusNode alloc] init];

	node.msg = [dic objectForKey: @"msg"];
	node.success = [[dic objectForKey: @"success"] boolValue];
	node.code = [[dic objectForKey: @"code"] longValue];
	node.data = [dic objectForKey: @"data"];

	return node;
}

@end