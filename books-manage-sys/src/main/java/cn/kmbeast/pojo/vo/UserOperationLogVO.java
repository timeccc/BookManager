package cn.kmbeast.pojo.vo;

import cn.kmbeast.pojo.entity.RssNotification;
import cn.kmbeast.pojo.entity.UserOperationLog;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
public class UserOperationLogVO extends UserOperationLog {
    private String userName;
}
