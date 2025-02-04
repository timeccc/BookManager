package cn.kmbeast.service.impl;

import cn.kmbeast.mapper.BookShelfMapper;
import cn.kmbeast.pojo.api.ApiResult;
import cn.kmbeast.pojo.api.PageResult;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.BookshelfQueryDto;
import cn.kmbeast.pojo.entity.BookShelf;
import cn.kmbeast.service.BookshelfService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * 书架业务逻辑实现
 */
@Service
public class BookshelfServiceImpl implements BookshelfService {

    @Resource
    private BookShelfMapper bookshelfMapper;

    /**
     * 书架新增
     *
     * @param bookShelf 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> save(BookShelf bookShelf) {
        bookshelfMapper.save(bookShelf);
        return ApiResult.success();
    }

    /**
     * 书架删除
     *
     * @param ids 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> batchDelete(List<Integer> ids) {
        bookshelfMapper.batchDelete(ids);
        return ApiResult.success();
    }

    /**
     * 书架修改
     *
     * @param bookShelf 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> update(BookShelf bookShelf) {
        bookshelfMapper.update(bookShelf);
        return ApiResult.success();
    }

    /**
     * 书架查询
     *
     * @param bookshelfQueryDto 查询参数
     * @return Result<List < BookShelf>>
     */
    @Override
    public Result<List<BookShelf>> query(BookshelfQueryDto bookshelfQueryDto) {
        List<BookShelf> noticeList = bookshelfMapper.query(bookshelfQueryDto);
        Integer totalCount = bookshelfMapper.queryCount(bookshelfQueryDto);
        return PageResult.success(noticeList, totalCount);
    }


}
