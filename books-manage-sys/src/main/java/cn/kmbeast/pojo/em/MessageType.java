package cn.kmbeast.pojo.em;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum MessageType {

    // 互动消息（评论被被人回复、评论被别人点赞）、指标消息、系统通知类
    EVALUATIONS_BY_REPLY(1,"评论"),
    EVALUATIONS_BY_UPVOTE(2,"点赞"),
    DATA_MESSAGE(3,"指标提醒"),
    SYSTEM_INFO(4,"系统通知");

    /**
     * 消息类型
     */
    private final Integer type;

    /**
     * 消息类型的备注
     */
    private final String detail;

}
