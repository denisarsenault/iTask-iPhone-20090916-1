/*

*/

#import "NSString+SBItask.h"
#import "SBItask.h"


@implementation NSString (NSString_SBItask)

- (id)ItaskFragmentValue
{
    SBItask *Itask = [[SBItask new] autorelease];
    
    NSError *error;
    id o = [Itask fragmentWithString:self error:&error];
    
    if (!o)
        NSLog(@"%@", error);
    return o;
}

- (id)ItaskValue
{
    SBItask *Itask = [[SBItask new] autorelease];
    
    NSError *error;
    id o = [Itask objectWithString:self error:&error];
    
    if (!o)
        NSLog(@"%@", error);
    return o;
}

@end
