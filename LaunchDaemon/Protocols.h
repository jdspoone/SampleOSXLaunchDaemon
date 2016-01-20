/*

  Written by Jeff Spooner

  The NSXPCConnection API requires that the server object in an XPC communication conform to
  some protocol. However no such restriction applies for the client object, as the client 
  can pass a completion block to the server in the original message. This is a marked improvement 
  over the old Distributed Objects API.

  Methods intended to be called over XPC must return void

  The protocol is is declared in a dedicated file as both the client and daemon need to know about it.

*/


static NSString *daemonLabel = @"com.example.daemon";


@protocol ExampleDaemonProtocol

- (void) incrementCount;

- (void) getCount:(void(^)(int count))completion;

@end