package cn.kmbeast.service;

import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.RssNotificationQueryDto;
import cn.kmbeast.pojo.entity.RssNotification;
import cn.kmbeast.pojo.vo.RssNotificationVO;

import java.util.List;

/**
 * 订阅通知的业务逻辑接口
 */
public interface RssNotificationService {

    Result<Void> save(RssNotification rssNotification);

    Result<Void> batchDelete(List<Integer> ids);

    Result<Void> update(RssNotification rssNotification);

    Result<List<RssNotificationVO>> query(RssNotificationQueryDto rssNotificationQueryDto);

    Result<Void> postBook(Integer id);

    Result<List<Void>> readDeal();



}
