package com.okta.netty;

import io.netty.channel.Channel;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelPipeline;
import io.netty.handler.codec.redis.RedisDecoder;
import io.netty.handler.codec.redis.RedisEncoder;

public class RedisServerInitializer extends ChannelInitializer<Channel> {

    @Override
    protected void initChannel(Channel ch) {
        ChannelPipeline pipeline = ch.pipeline();
        
        // doesn't make sense
        // pipeline.addLast(new RedisEncoder());

        // why is this?
        pipeline.addLast(new RedisDecoder());
        pipeline.addLast(new RedisServerHandler());
    }

}
