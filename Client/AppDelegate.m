/*

  Written by Jeff Spooner

  XPC allows clients to pass completion blocks as parameters to messages to the server,
  removing the need to have explicit methods which the server calls on the client. This
  is a really nice improvement over the old Distributed Objects API.

*/

#import "AppDelegate.h"
#import "Protocols.h"


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (nonatomic, strong, readwrite) NSXPCConnection *connection;

@end


@implementation AppDelegate


- (NSXPCConnection *) connection
  {
    // Create the XPC Connection on demand
    if (_connection == nil) {
      _connection = [[NSXPCConnection alloc] initWithMachServiceName:daemonLabel options:NSXPCConnectionPrivileged];
      _connection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(ExampleDaemonProtocol)];
      _connection.invalidationHandler =
          ^{
            _connection = nil;
            NSLog(@"connection has been invalidated");
          };

      // New connections always start in a suspended state
      [_connection resume];
    }
    return _connection;
  }


- (IBAction) incrementCount:(id)sender
  {
    [self.connection.remoteObjectProxy incrementCount];
  }


- (IBAction) getCount:(id)sender
  {
    [self.connection.remoteObjectProxy getCount:
        ^(int count) {
            NSLog(@"daemon's count is %d", count);
        }];
  }


#pragma mark - CFNotificationCenter

static void notificationCenterCallBack(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
  {
    NSLog(@"daemon has incremented it's count");
  }


#pragma mark - NSApplicationDelegate

- (void) applicationDidFinishLaunching:(NSNotification *)notification
  {
    // Register to observe Darwin notifications
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)self, notificationCenterCallBack, CFSTR("com.example.daemonCounterDidChange"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  }


- (void) applicationWillTerminate:(NSNotification *)notification
  {
    // Unregister to observe Darwin notifications
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)self, CFSTR("com.example.daemonCounterDidChange"), NULL);
  }


- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
  { return YES; }


@end
