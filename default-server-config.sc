+Can {
	*defaultServerConfig {
		var server;
		Server.default.options.memSize= 512000*20;
		Server.default.options.numWireBufs= 512;
		server = Server.local;
		server.latency = 0.05;
		^server
	}
}