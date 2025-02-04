package cn.kmbeast.service.impl;

import cn.kmbeast.context.LocalThreadHolder;
import cn.kmbeast.mapper.BookRssHistoryMapper;
import cn.kmbeast.pojo.api.ApiResult;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.BookRssHistoryQueryDto;
import cn.kmbeast.pojo.entity.BookRssHistory;
import cn.kmbeast.pojo.vo.BookRssHistoryVO;
import cn.kmbeast.service.BookRssHistoryService;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 书籍订阅业务逻辑实现
 */
@Service
public class BookRssHistoryServiceImpl implements BookRssHistoryService {

    @Resource
    private BookRssHistoryMapper bookRssHistoryMapper;

    /**
     * 书籍订阅新增
     *
     * @param bookRssHistory 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> save(BookRssHistory bookRssHistory) {
        // 如果这个用户订阅了这本书，就不能去继续订阅了
        BookRssHistoryQueryDto dto = new BookRssHistoryQueryDto();
        dto.setUserId(LocalThreadHolder.getUserId());
        dto.setBookId(bookRssHistory.getBookId());
        List<BookRssHistoryVO> bookRssHistoryVOS = bookRssHistoryMapper.query(dto);
        if (!CollectionUtils.isEmpty(bookRssHistoryVOS)) {
            return ApiResult.error("该本书已经订阅，请勿重复操作");
        }
        bookRssHistory.setCreateTime(LocalDateTime.now());
        bookRssHistory.setUserId(LocalThreadHolder.getUserId());
        bookRssHistoryMapper.save(bookRssHistory);
        return ApiResult.success();
    }

    /**
     * 书籍订阅删除
     *
     * @param ids 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> batchDelete(List<Integer> ids) {
        bookRssHistoryMapper.batchDelete(ids);
        return ApiResult.success();
    }

    /**
     * 书籍订阅修改
     *
     * @param bookRssHistory 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> update(BookRssHistory bookRssHistory) {
        bookRssHistoryMapper.update(bookRssHistory);
        return ApiResult.success();
    }

    /**
     * 书籍订阅查询
     *
     * @param dto 查询参数
     * @return Result<List < BookRssHistoryVO>>
     */
    @Override
    public Result<List<BookRssHistoryVO>> query(BookRssHistoryQueryDto dto) {
        List<BookRssHistoryVO> bookRssHistoryVOS = bookRssHistoryMapper.query(dto);
        Integer totalCount = bookRssHistoryMapper.queryCount(dto);
        return ApiResult.success(bookRssHistoryVOS, totalCount);
    }


}
