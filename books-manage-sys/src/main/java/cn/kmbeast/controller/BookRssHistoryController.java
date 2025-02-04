package cn.kmbeast.controller;

import cn.kmbeast.aop.Pager;
import cn.kmbeast.context.LocalThreadHolder;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.BookRssHistoryQueryDto;
import cn.kmbeast.pojo.entity.BookRssHistory;
import cn.kmbeast.pojo.vo.BookRssHistoryVO;
import cn.kmbeast.service.BookRssHistoryService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * 书籍订阅的 Controller
 */
@RestController
@RequestMapping(value = "/bookRssHistory")
public class BookRssHistoryController {

    @Resource
    private BookRssHistoryService bookRssHistoryService;

    /**
     * 书籍订阅新增
     *
     * @param bookRssHistory 新增数据
     * @return Result<Void> 通用响应体
     */
    @PostMapping(value = "/save")
    public Result<Void> save(@RequestBody BookRssHistory bookRssHistory) {
        return bookRssHistoryService.save(bookRssHistory);
    }

    /**
     * 书籍订阅删除
     *
     * @param ids 要删除的书籍订阅ID列表
     * @return Result<Void> 通用响应体
     */
    @PostMapping(value = "/batchDelete")
    public Result<Void> batchDelete(@RequestBody List<Integer> ids) {
        return bookRssHistoryService.batchDelete(ids);
    }

    /**
     * 书籍订阅修改
     *
     * @param bookRssHistory 参数
     * @return Result<Void> 响应
     */
    @PutMapping(value = "/update")
    public Result<Void> update(@RequestBody BookRssHistory bookRssHistory) {
        return bookRssHistoryService.update(bookRssHistory);
    }

    /**
     * 书籍订阅用户查询
     *
     * @param bookRssHistoryQueryDto 查询参数
     * @return Result<List < BookRssHistoryVO>> 通用响应
     */
    @Pager
    @PostMapping(value = "/queryUser")
    public Result<List<BookRssHistoryVO>> queryUser(@RequestBody BookRssHistoryQueryDto bookRssHistoryQueryDto) {
        bookRssHistoryQueryDto.setUserId(LocalThreadHolder.getUserId());
        return bookRssHistoryService.query(bookRssHistoryQueryDto);
    }


    /**
     * 书籍订阅查询
     *
     * @param bookRssHistoryQueryDto 查询参数
     * @return Result<List < BookRssHistoryVO>> 通用响应
     */
    @Pager
    @PostMapping(value = "/query")
    public Result<List<BookRssHistoryVO>> query(@RequestBody BookRssHistoryQueryDto bookRssHistoryQueryDto) {
        return bookRssHistoryService.query(bookRssHistoryQueryDto);
    }

}
