package cn.kmbeast.mapper;

import cn.kmbeast.pojo.dto.query.extend.BookSaveQueryDto;
import cn.kmbeast.pojo.entity.BookSave;
import cn.kmbeast.pojo.vo.BookSaveVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 书籍收藏持久化接口
 */
@Mapper
public interface BookSaveMapper {

    void save(BookSave bookSave);

    void update(BookSave bookSave);

    void batchDelete(@Param(value = "ids") List<Integer> ids);

    List<BookSaveVO> query(BookSaveQueryDto bookSaveQueryDto);

    Integer queryCount(BookSaveQueryDto bookSaveQueryDto);

}
