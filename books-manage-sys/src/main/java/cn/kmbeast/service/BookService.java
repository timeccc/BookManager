package cn.kmbeast.service;

import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.BookQueryDto;
import cn.kmbeast.pojo.entity.Book;
import cn.kmbeast.pojo.vo.BookVO;
import cn.kmbeast.pojo.vo.ChartVO;

import java.util.List;

/**
 * 书籍业务逻辑接口
 */
public interface BookService {

    Result<Void> save(Book book);

    Result<Void> batchDelete(List<Integer> ids);

    Result<Void> update(Book book);

    Result<List<BookVO>> query(BookQueryDto bookQueryDto);

    Result<List<ChartVO>> daysQuery(Integer day);

}
