/*

*/

#import "NSObject+SBItask.h"
#import "SBItask.h"

@implementation NSObject (NSObject_SBItask)

- (NSString *)ItaskFragment {
    SBItask *generator = [[SBItask new] autorelease];
    
    NSError *error;
    NSString *Itask = [generator stringWithFragment:self error:&error];
    
    if (!Itask)
        NSLog(@"%@", error);
    return Itask;
}

- (NSString *)ItaskRepresentation {
    SBItask *generator = [[SBItask new] autorelease];
    
    NSError *error;
    NSString *Itask = [generator stringWithObject:self error:&error];
    
    if (!Itask)
        NSLog(@"%@", error);
    return Itask;
}

@end
