/*

  Written by Jeff Spooner

  If you're writing a system which has a daemon and multiple clients, particularly
  if your clients need to sync some state with the daemon from time to time, you'll 
  want a way for the daemon to initiate contact. Having each client maintain an XPC 
  listener, and making the daemon send a message to each client when something changes
  is not a very good or viable solution, using CFNotificationCenter is much better. 
  When something changes the daemon can post a notification, and upon receipt the 
  clients can send the appropriate message to the daemon over XPC.

*/

#import "Daemon.h"
#import "notify.h"

@interface Daemon () <NSXPCListenerDelegate, ExampleDaemonProtocol>

@property (nonatomic, strong, readwrite) NSXPCListener *listener;
@property (nonatomic, readwrite) BOOL started;

@property (nonatomic, readwrite) int count;

@end


@implementation Daemon

- (id) init
  {
    // Launch daemons must configure their listener with the machServiceName initializer
    _listener = [[NSXPCListener alloc] initWithMachServiceName:daemonLabel];
    _listener.delegate = self;

    _started = NO;

    return self;
  }


- (void) start
  {
    assert(_started == NO);

    // Begin listening for incoming XPC connections
    [_listener resume];

    _started = YES;
  }


- (void) stop
  {
    assert(_started == YES);

    // Stop listening for incoming XPC connections
    [_listener suspend];

    _started = NO;
  }


#pragma mark - ExampleDaemonProtocol

- (void) incrementCount
  {
    // Incrememnt the counter
    _count++;

    // Post a notification
    notify_post("com.example.daemonCounterDidChange");
  }


- (void) getCount:(void (^)(int))completion
  {
    // Pass our count back in the completion block
    completion(_count);
  }


#pragma mark - NSXPCListenerDelegate

- (BOOL) listener:(NSXPCListener *)listener shouldAcceptNewConnection:(NSXPCConnection *)newConnection
  {
    // Sanity checks
    assert(listener == _listener);
    assert(newConnection != nil);

    // Configure the incoming connection
    newConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol:@protocol(ExampleDaemonProtocol)];
    newConnection.exportedObject = self;

    // New connections always start in a suspended state
    [newConnection resume];

    return YES;
  }


@end
