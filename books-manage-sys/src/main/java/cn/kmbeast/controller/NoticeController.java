package cn.kmbeast.controller;

import cn.kmbeast.aop.Pager;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.NoticeQueryDto;
import cn.kmbeast.pojo.entity.Notice;
import cn.kmbeast.service.NoticeService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * 公告的 Controller
 */
@RestController
@RequestMapping(value = "/notice")
public class NoticeController {

    @Resource
    private NoticeService noticeService;

    /**
     * 公告新增
     *
     * @param notice 新增数据
     * @return Result<Void> 通用响应体
     */
    @PostMapping(value = "/save")
    public Result<Void> save(@RequestBody Notice notice) {
        return noticeService.save(notice);
    }

    /**
     * 公告删除
     *
     * @param ids 要删除的公告ID列表
     * @return Result<Void> 通用响应体
     */
    @PostMapping(value = "/batchDelete")
    public Result<Void> batchDelete(@RequestBody List<Integer> ids) {
        return noticeService.batchDelete(ids);
    }

    /**
     * 公告修改
     *
     * @param notice 参数
     * @return Result<Void> 响应
     */
    @PutMapping(value = "/update")
    public Result<Void> update(@RequestBody Notice notice) {
        return noticeService.update(notice);
    }

    /**
     * 公告查询
     *
     * @param noticeQueryDto 查询参数
     * @return Result<List < Notice>> 通用响应
     */
    @Pager
    @PostMapping(value = "/query")
    public Result<List<Notice>> query(@RequestBody NoticeQueryDto noticeQueryDto) {
        return noticeService.query(noticeQueryDto);
    }

}
