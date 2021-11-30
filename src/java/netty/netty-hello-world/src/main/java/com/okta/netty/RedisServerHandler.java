package com.okta.netty;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.SimpleChannelInboundHandler;
import io.netty.handler.codec.redis.RedisMessage;
import io.netty.util.CharsetUtil;

public class RedisServerHandler extends SimpleChannelInboundHandler<RedisMessage> {

    @Override
    protected void channelRead0(ChannelHandlerContext ctx, RedisMessage msg) {
        /*ByteBuf content = Unpooled.copiedBuffer("Hello World!", CharsetUtil.UTF_8);
        FullHttpResponse response = new DefaultFullHttpResponse(HttpVersion.HTTP_1_1, HttpResponseStatus.OK, content);
        response.headers().set(HttpHeaderNames.CONTENT_TYPE, "text/html");
        response.headers().set(HttpHeaderNames.CONTENT_LENGTH, content.readableBytes());
        ctx.write(response);
        ctx.flush();*/

        // message received
        System.out.println("-- message received --");
        System.out.println(msg);
    }

}
