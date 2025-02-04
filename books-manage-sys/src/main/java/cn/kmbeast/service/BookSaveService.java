package cn.kmbeast.service;

import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.BookSaveQueryDto;
import cn.kmbeast.pojo.entity.BookSave;
import cn.kmbeast.pojo.vo.BookSaveVO;

import java.util.List;

/**
 * 书籍收藏业务逻辑接口
 */
public interface BookSaveService {

    Result<Void> save(BookSave bookSave);

    Result<Void> batchDelete(List<Integer> ids);

    Result<Void> update(BookSave bookSave);

    Result<List<BookSaveVO>> query(BookSaveQueryDto bookSaveQueryDto);

}
