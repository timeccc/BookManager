package cn.kmbeast.mapper;

import cn.kmbeast.pojo.dto.query.extend.BookOrderHistoryQueryDto;
import cn.kmbeast.pojo.entity.BookOrderHistory;
import cn.kmbeast.pojo.vo.BookOrderHistoryVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 书籍预约历史持久化接口
 */
@Mapper
public interface BookOrderHistoryMapper {

    void save(BookOrderHistory bookOrderHistory);

    void update(BookOrderHistory bookOrderHistory);

    void batchDelete(@Param(value = "ids") List<Integer> ids);

    List<BookOrderHistoryVO> query(BookOrderHistoryQueryDto dto);

    Integer queryCount(BookOrderHistoryQueryDto dto);

}
