package cn.kmbeast.controller;

import cn.kmbeast.aop.Pager;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.BookshelfQueryDto;
import cn.kmbeast.pojo.entity.BookShelf;
import cn.kmbeast.service.BookshelfService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * 书架的 Controller
 */
@RestController
@RequestMapping(value = "/bookshelf")
public class BookshelfController {

    @Resource
    private BookshelfService bookshelfService;

    /**
     * 书架新增
     *
     * @param bookShelf 新增数据
     * @return Result<Void> 通用响应体
     */
    @PostMapping(value = "/save")
    public Result<Void> save(@RequestBody BookShelf bookShelf) {
        return bookshelfService.save(bookShelf);
    }

    /**
     * 书架删除
     *
     * @param ids 要删除的书架ID列表
     * @return Result<Void> 通用响应体
     */
    @PostMapping(value = "/batchDelete")
    public Result<Void> batchDelete(@RequestBody List<Integer> ids) {
        return bookshelfService.batchDelete(ids);
    }

    /**
     * 书架修改
     *
     * @param bookShelf 参数
     * @return Result<Void> 响应
     */
    @PutMapping(value = "/update")
    public Result<Void> update(@RequestBody BookShelf bookShelf) {
        return bookshelfService.update(bookShelf);
    }

    /**
     * 书架查询
     *
     * @param bookshelfQueryDto 查询参数
     * @return Result<List < BookShelf>> 通用响应
     */
    @Pager
    @PostMapping(value = "/query")
    public Result<List<BookShelf>> query(@RequestBody BookshelfQueryDto bookshelfQueryDto) {
        return bookshelfService.query(bookshelfQueryDto);
    }

}
