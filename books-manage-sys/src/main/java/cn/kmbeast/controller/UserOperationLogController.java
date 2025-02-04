package cn.kmbeast.controller;

import cn.kmbeast.aop.Pager;
import cn.kmbeast.context.LocalThreadHolder;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.UserOperationLogQueryDto;
import cn.kmbeast.pojo.entity.UserOperationLog;
import cn.kmbeast.pojo.vo.UserOperationLogVO;
import cn.kmbeast.service.UserOperationLogService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * 用户行为日志的 Controller
 */
@RestController
@RequestMapping(value = "/userOperationLog")
public class UserOperationLogController {

    @Resource
    private UserOperationLogService userOperationLogService;

    /**
     * 用户行为日志新增
     *
     * @param userOperationLog 新增数据
     * @return Result<Void> 通用响应体
     */
    @PostMapping(value = "/save")
    public Result<Void> save(@RequestBody UserOperationLog userOperationLog) {
        return userOperationLogService.save(userOperationLog);
    }

    /**
     * 用户行为日志删除
     *
     * @param ids 要删除的用户行为日志ID列表
     * @return Result<Void> 通用响应体
     */
    @PostMapping(value = "/batchDelete")
    public Result<Void> batchDelete(@RequestBody List<Integer> ids) {
        return userOperationLogService.batchDelete(ids);
    }

    /**
     * 用户行为日志修改
     *
     * @param userOperationLog 参数
     * @return Result<Void> 响应
     */
    @PutMapping(value = "/update")
    public Result<Void> update(@RequestBody UserOperationLog userOperationLog) {
        return userOperationLogService.update(userOperationLog);
    }

    /**
     * 用户行为日志，查询用户需要接收的
     *
     * @param dto 查询参数
     * @return Result<List < UserOperationLogVO>> 通用响应
     */
    @Pager
    @PostMapping(value = "/queryUser")
    public Result<List<UserOperationLogVO>> queryUser(@RequestBody UserOperationLogQueryDto dto) {
        dto.setUserId(LocalThreadHolder.getUserId());
        return userOperationLogService.query(dto);
    }

    /**
     * 用户行为日志查询
     *
     * @param dto 查询参数
     * @return Result<List < UserOperationLogVO>> 通用响应
     */
    @Pager
    @PostMapping(value = "/query")
    public Result<List<UserOperationLogVO>> query(@RequestBody UserOperationLogQueryDto dto) {
        return userOperationLogService.query(dto);
    }

}
