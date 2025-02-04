package cn.kmbeast.pojo.vo;

import cn.kmbeast.pojo.entity.RssNotification;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
public class RssNotificationVO extends RssNotification {
    private String userName;
}
