package cn.kmbeast.mapper;

import cn.kmbeast.pojo.dto.query.extend.BookRssHistoryQueryDto;
import cn.kmbeast.pojo.entity.BookRssHistory;
import cn.kmbeast.pojo.vo.BookRssHistoryVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 书籍订阅历史持久化接口
 */
@Mapper
public interface BookRssHistoryMapper {

    void save(BookRssHistory bookRssHistory);

    void update(BookRssHistory bookRssHistory);

    void batchDelete(@Param(value = "ids") List<Integer> ids);

    List<BookRssHistoryVO> query(BookRssHistoryQueryDto dto);

    Integer queryCount(BookRssHistoryQueryDto dto);

}
