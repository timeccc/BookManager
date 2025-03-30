package cn.kmbeast.service.impl;

import cn.kmbeast.context.LocalThreadHolder;
import cn.kmbeast.mapper.BookMapper;
import cn.kmbeast.mapper.BookRssHistoryMapper;
import cn.kmbeast.mapper.RssNotificationMapper;
import cn.kmbeast.pojo.api.ApiResult;
import cn.kmbeast.pojo.api.PageResult;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.base.QueryDto;
import cn.kmbeast.pojo.dto.query.extend.BookQueryDto;
import cn.kmbeast.pojo.dto.query.extend.BookRssHistoryQueryDto;
import cn.kmbeast.pojo.entity.Book;
import cn.kmbeast.pojo.entity.RssNotification;
import cn.kmbeast.pojo.vo.BookRssHistoryVO;
import cn.kmbeast.pojo.vo.BookVO;
import cn.kmbeast.pojo.vo.ChartVO;
import cn.kmbeast.service.BookService;
import cn.kmbeast.utils.DateUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 书籍业务逻辑实现
 */
@Service
public class BookServiceImpl implements BookService {

    @Resource
    private BookMapper bookMapper;
    @Resource
    private BookRssHistoryMapper bookRssHistoryMapper;
    @Resource
    private RssNotificationMapper rssNotificationMapper;

    /**
     * 书籍新增
     *
     * @param book 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> save(Book book) {
        if (book.getIsPlanBuy() == null) {
            book.setIsPlanBuy(false);
        }
        book.setCreateTime(LocalDateTime.now());
        bookMapper.save(book);
        return ApiResult.success();
    }

    /**
     * 书籍删除
     *
     * @param ids 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> batchDelete(List<Integer> ids) {
        bookMapper.batchDelete(ids);
        return ApiResult.success();
    }

    /**
     * 书籍修改
     *
     * @param book 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> update(Book book) {
        // 书籍上线处理
        bookPost(book);
        bookMapper.update(book);
        return ApiResult.success();
    }

    /**
     * 书籍上线逻辑处理，给订阅了该书籍的用户发送通知
     *
     * @param book 书籍
     */
    private void bookPost(Book book) {
        // 书籍已经上线
        if (!book.getIsPlanBuy()) {
            BookRssHistoryQueryDto queryDto = new BookRssHistoryQueryDto();
            queryDto.setBookId(book.getId());
            // 订阅配置
            List<BookRssHistoryVO> rssHistoryVOS = bookRssHistoryMapper.query(queryDto);
            // 取得订阅了该书籍的用户ID
            List<Integer> userIds = rssHistoryVOS.stream().map(BookRssHistoryVO::getUserId)
                    .collect(Collectors.toList());
            List<RssNotification> rssNotifications = new ArrayList<>();
            String content = "您好，您订阅的由" + book.getAuthor() + "创作的书籍【" + book.getName() + "】已经上线，可以借阅了";
            for (Integer userId : userIds) {
                RssNotification rssNotification = new RssNotification(
                        null,
                        userId,
                        content,
                        false,
                        LocalDateTime.now()
                );
                rssNotifications.add(rssNotification);
            }
            if (rssNotifications.isEmpty()){
                return;
            }
            rssNotificationMapper.save(rssNotifications);
        }
    }

    /**
     * 书籍查询
     *
     * @param bookQueryDto 查询参数
     * @return Result<List < BookVO>>
     */
    @Override
    public Result<List<BookVO>> query(BookQueryDto bookQueryDto) {
        bookQueryDto.setUserId(LocalThreadHolder.getUserId());
        List<BookVO> noticeList = bookMapper.query(bookQueryDto);
        Integer totalCount = bookMapper.queryCount(bookQueryDto);
        return PageResult.success(noticeList, totalCount);
    }


    /**
     * 统计指定时间里面的图书上架情况
     *
     * @param day 天数
     * @return Result<List < ChartVO>>
     */
    @Override
    public Result<List<ChartVO>> daysQuery(Integer day) {
        QueryDto queryDto = DateUtil.startAndEndTime(day);
        BookQueryDto bookQueryDto = new BookQueryDto();
        bookQueryDto.setStartTime(queryDto.getStartTime());
        bookQueryDto.setEndTime(queryDto.getEndTime());
        List<BookVO> bookVOS = bookMapper.query(bookQueryDto);
        List<LocalDateTime> localDateTimes = bookVOS.stream().map(BookVO::getCreateTime).collect(Collectors.toList());
        List<ChartVO> chartVOS = DateUtil.countDatesWithinRange(day, localDateTimes);
        return ApiResult.success(chartVOS);
    }
}
