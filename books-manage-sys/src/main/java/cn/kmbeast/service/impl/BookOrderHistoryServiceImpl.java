package cn.kmbeast.service.impl;

import cn.kmbeast.mapper.BookOrderHistoryMapper;
import cn.kmbeast.pojo.api.ApiResult;
import cn.kmbeast.pojo.api.PageResult;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.BookOrderHistoryQueryDto;
import cn.kmbeast.pojo.entity.BookOrderHistory;
import cn.kmbeast.pojo.vo.BookOrderHistoryVO;
import cn.kmbeast.service.BookOrderHistoryService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 书籍借阅历史业务逻辑实现
 */
@Service
public class BookOrderHistoryServiceImpl implements BookOrderHistoryService {

    @Resource
    private BookOrderHistoryMapper bookOrderHistoryMapper;

    /**
     * 保存书籍借阅历史
     *
     * @param bookOrderHistory 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> save(BookOrderHistory bookOrderHistory) {
        if (bookOrderHistory.getCreateTime() == null) {
            bookOrderHistory.setCreateTime(LocalDateTime.now());
        }
        bookOrderHistoryMapper.save(bookOrderHistory);
        return ApiResult.success();
    }

    /**
     * 批量删除书籍借阅历史
     *
     * @param ids 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> batchDelete(List<Integer> ids) {
        bookOrderHistoryMapper.batchDelete(ids);
        return ApiResult.success();
    }

    /**
     * 更新书籍借阅历史
     *
     * @param bookOrderHistory 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> update(BookOrderHistory bookOrderHistory) {
        bookOrderHistoryMapper.update(bookOrderHistory);
        return ApiResult.success();
    }

    /**
     * 书籍借阅历史查询
     *
     * @param bookOrderHistoryQueryDto 查询参数
     * @return Result<List<BookOrderHistoryVO>>
     */
    @Override
    public Result<List<BookOrderHistoryVO>> query(BookOrderHistoryQueryDto bookOrderHistoryQueryDto) {
        List<BookOrderHistoryVO> historyList = bookOrderHistoryMapper.query(bookOrderHistoryQueryDto);
        Integer totalCount = bookOrderHistoryMapper.queryCount(bookOrderHistoryQueryDto);
        return PageResult.success(historyList, totalCount);
    }
}
