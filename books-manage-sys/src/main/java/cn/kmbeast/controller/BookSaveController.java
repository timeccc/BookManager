package cn.kmbeast.controller;

import cn.kmbeast.aop.Pager;
import cn.kmbeast.context.LocalThreadHolder;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.BookSaveQueryDto;
import cn.kmbeast.pojo.entity.BookSave;
import cn.kmbeast.pojo.vo.BookSaveVO;
import cn.kmbeast.service.BookSaveService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * 书架收藏的 Controller
 */
@RestController
@RequestMapping(value = "/bookSave")
public class BookSaveController {

    @Resource
    private BookSaveService bookSaveService;

    /**
     * 书架收藏新增
     *
     * @param bookSave 新增数据
     * @return Result<Void> 通用响应体
     */
    @PostMapping(value = "/save")
    public Result<Void> save(@RequestBody BookSave bookSave) {
        return bookSaveService.save(bookSave);
    }

    /**
     * 书架收藏删除
     *
     * @param ids 要删除的书架收藏ID列表
     * @return Result<Void> 通用响应体
     */
    @PostMapping(value = "/batchDelete")
    public Result<Void> batchDelete(@RequestBody List<Integer> ids) {
        return bookSaveService.batchDelete(ids);
    }

    /**
     * 书架收藏修改
     *
     * @param bookSave 参数
     * @return Result<Void> 响应
     */
    @PutMapping(value = "/update")
    public Result<Void> update(@RequestBody BookSave bookSave) {
        return bookSaveService.update(bookSave);
    }

    /**
     * 书架收藏用户查询
     *
     * @param bookSaveQueryDto 查询参数
     * @return Result<List < BookSaveVO>> 通用响应
     */
    @Pager
    @PostMapping(value = "/queryUser")
    public Result<List<BookSaveVO>> queryUser(@RequestBody BookSaveQueryDto bookSaveQueryDto) {
        bookSaveQueryDto.setUserId(LocalThreadHolder.getUserId());
        return bookSaveService.query(bookSaveQueryDto);
    }


    /**
     * 书架收藏查询
     *
     * @param bookSaveQueryDto 查询参数
     * @return Result<List < BookSaveVO>> 通用响应
     */
    @Pager
    @PostMapping(value = "/query")
    public Result<List<BookSaveVO>> query(@RequestBody BookSaveQueryDto bookSaveQueryDto) {
        return bookSaveService.query(bookSaveQueryDto);
    }

}
