package cn.kmbeast.service;

import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.RssNotificationQueryDto;
import cn.kmbeast.pojo.dto.query.extend.UserOperationLogQueryDto;
import cn.kmbeast.pojo.entity.RssNotification;
import cn.kmbeast.pojo.entity.UserOperationLog;
import cn.kmbeast.pojo.vo.RssNotificationVO;
import cn.kmbeast.pojo.vo.UserOperationLogVO;

import java.util.List;

/**
 * 用户行为日志的业务逻辑接口
 */
public interface UserOperationLogService {

    Result<Void> save(UserOperationLog userOperationLog);

    Result<Void> batchDelete(List<Integer> ids);

    Result<Void> update(UserOperationLog userOperationLog);

    Result<List<UserOperationLogVO>> query(UserOperationLogQueryDto dto);

}
