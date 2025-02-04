package cn.kmbeast.service;

import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.BookOrderHistoryQueryDto;
import cn.kmbeast.pojo.dto.query.extend.NoticeQueryDto;
import cn.kmbeast.pojo.entity.BookOrderHistory;
import cn.kmbeast.pojo.entity.Notice;
import cn.kmbeast.pojo.vo.BookOrderHistoryVO;

import java.util.List;

/**
 * 书籍预约历史业务逻辑接口
 */
public interface BookOrderHistoryService {

    Result<Void> save(BookOrderHistory BookOrderHistory);

    Result<Void> batchDelete(List<Integer> ids);

    Result<Void> update(BookOrderHistory BookOrderHistory);

    Result<List<BookOrderHistoryVO>> query(BookOrderHistoryQueryDto dto);

}
