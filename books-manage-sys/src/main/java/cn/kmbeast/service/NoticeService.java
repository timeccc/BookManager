package cn.kmbeast.service;

import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.NoticeQueryDto;
import cn.kmbeast.pojo.entity.Notice;

import java.util.List;

/**
 * 公告业务逻辑接口
 */
public interface NoticeService {

    Result<Void> save(Notice notice);

    Result<Void> batchDelete(List<Integer> ids);

    Result<Void> update(Notice notice);

    Result<List<Notice>> query(NoticeQueryDto noticeQueryDto);

}
