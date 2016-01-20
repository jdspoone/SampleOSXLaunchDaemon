/*
  
  Written by Jeff Spooner

*/

#import <Foundation/Foundation.h>
#import "Protocols.h"

@interface Daemon : NSObject

- (id) init;

- (void) start;
    // Begin listening for incoming XPC connections

- (void) stop;
    // Stop listening for incoming XPC connections

@end
