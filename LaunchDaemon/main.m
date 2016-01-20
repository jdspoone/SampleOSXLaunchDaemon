/*
  
  Written by Jeff Spooner

*/

#import "Daemon.h"


int main(int argc, const char *argv[])
  {
    // Create an instance of the daemon and start it
    Daemon *daemon = [[Daemon alloc] init];
    [daemon start];

    // Loop indefinitely
    [[NSRunLoop currentRunLoop] run];

    return 0;
  }
