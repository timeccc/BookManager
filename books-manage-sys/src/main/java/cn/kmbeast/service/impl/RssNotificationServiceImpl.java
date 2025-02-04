package cn.kmbeast.service.impl;

import cn.kmbeast.context.LocalThreadHolder;
import cn.kmbeast.mapper.BookMapper;
import cn.kmbeast.mapper.BookRssHistoryMapper;
import cn.kmbeast.mapper.RssNotificationMapper;
import cn.kmbeast.pojo.api.ApiResult;
import cn.kmbeast.pojo.api.PageResult;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.BookRssHistoryQueryDto;
import cn.kmbeast.pojo.dto.query.extend.RssNotificationQueryDto;
import cn.kmbeast.pojo.entity.Book;
import cn.kmbeast.pojo.entity.RssNotification;
import cn.kmbeast.pojo.vo.BookRssHistoryVO;
import cn.kmbeast.pojo.vo.RssNotificationVO;
import cn.kmbeast.service.RssNotificationService;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 订阅通知业务逻辑实现
 */
@Service
public class RssNotificationServiceImpl implements RssNotificationService {

    @Resource
    private RssNotificationMapper rssNotificationMapper;
    @Resource
    private BookRssHistoryMapper bookRssHistoryMapper;
    @Resource
    private BookMapper bookMapper;

    /**
     * 订阅通知新增
     *
     * @param rssNotification 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> save(RssNotification rssNotification) {
        rssNotification.setCreateTime(LocalDateTime.now());
        List<RssNotification> rssNotifications = new ArrayList<>();
        rssNotifications.add(rssNotification);
        rssNotificationMapper.save(rssNotifications);
        return ApiResult.success();
    }

    /**
     * 订阅通知删除
     *
     * @param ids 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> batchDelete(List<Integer> ids) {
        rssNotificationMapper.batchDelete(ids);
        return ApiResult.success();
    }

    /**
     * 订阅通知修改
     *
     * @param rssNotification 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> update(RssNotification rssNotification) {
        rssNotificationMapper.update(rssNotification);
        return ApiResult.success();
    }

    /**
     * 订阅通知查询
     *
     * @param dto 查询参数
     * @return Result<List < Notice>>
     */
    @Override
    public Result<List<RssNotificationVO>> query(RssNotificationQueryDto dto) {
        List<RssNotificationVO> noticeList = rssNotificationMapper.query(dto);
        Integer totalCount = rssNotificationMapper.queryCount(dto);
        return PageResult.success(noticeList, totalCount);
    }

    /**
     * 书籍通知，转发消息
     *
     * @param id 书籍ID
     * @return Result<Void>
     */
    @Override
    public Result<Void> postBook(Integer id) {
        BookRssHistoryQueryDto dto = new BookRssHistoryQueryDto();
        dto.setBookId(id);
        // 把书籍的信息，修改状态
        Book book = new Book();
        book.setId(id);
        book.setIsPlanBuy(false);
        book.setPlanBuyTime(null);
        bookMapper.update(book);
        List<BookRssHistoryVO> rssHistoryVOS = bookRssHistoryMapper.query(dto);
        if (CollectionUtils.isEmpty(rssHistoryVOS)) {
            return ApiResult.success();
        }
        List<RssNotification> rssNotifications = new ArrayList<>();
        // 构造消息集合
        for (BookRssHistoryVO rssHistoryVO : rssHistoryVOS) {
            
            RssNotification rssNotification = new RssNotification();
            rssNotification.setUserId(rssHistoryVO.getUserId());
            rssNotification.setContent("你订阅的书籍【" + rssHistoryVO.getBookName() + "】已经上线了，可以借书了");
            rssNotification.setIsRead(false);
            rssNotification.setCreateTime(LocalDateTime.now());
            rssNotifications.add(rssNotification);
        }
        // 批量发消息
        rssNotificationMapper.save(rssNotifications);
        return ApiResult.success();
    }

    /**
     * 消息全部设置为已读
     *
     * @return Result<List < Void>> 通用响应
     */
    @Override
    public Result<List<Void>> readDeal() {
        rssNotificationMapper.readDeal(LocalThreadHolder.getUserId());
        return ApiResult.success();
    }
}
