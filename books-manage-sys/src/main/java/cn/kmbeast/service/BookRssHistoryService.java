package cn.kmbeast.service;

import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.BookOrderHistoryQueryDto;
import cn.kmbeast.pojo.dto.query.extend.BookRssHistoryQueryDto;
import cn.kmbeast.pojo.entity.BookOrderHistory;
import cn.kmbeast.pojo.entity.BookRssHistory;
import cn.kmbeast.pojo.vo.BookOrderHistoryVO;
import cn.kmbeast.pojo.vo.BookRssHistoryVO;

import java.util.List;

/**
 * 书籍订阅业务逻辑接口
 */
public interface BookRssHistoryService {

    Result<Void> save(BookRssHistory bookRssHistory);

    Result<Void> batchDelete(List<Integer> ids);

    Result<Void> update(BookRssHistory bookRssHistory);

    Result<List<BookRssHistoryVO>> query(BookRssHistoryQueryDto dto);

}
