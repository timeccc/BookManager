package cn.kmbeast.controller;

import cn.kmbeast.aop.Log;
import cn.kmbeast.aop.Pager;
import cn.kmbeast.context.LocalThreadHolder;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.ReaderProposalQueryDto;
import cn.kmbeast.pojo.entity.ReaderProposal;
import cn.kmbeast.pojo.vo.ReaderProposalVO;
import cn.kmbeast.service.ReaderProposalService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * 读者建议的 Controller
 */
@RestController
@RequestMapping(value = "/readerProposal")
public class ReaderProposalController {

    @Resource
    private ReaderProposalService readerProposalService;

    /**
     * 读者建议新增
     *
     * @param readerProposal 新增数据
     * @return Result<Void> 通用响应体
     */
    @PostMapping(value = "/save")
    @Log(content = "向系统提交建议")
    public Result<Void> save(@RequestBody ReaderProposal readerProposal) {
        return readerProposalService.save(readerProposal);
    }

    /**
     * 读者建议删除
     *
     * @param ids 要删除的读者建议ID列表
     * @return Result<Void> 通用响应体
     */
    @PostMapping(value = "/batchDelete")
    public Result<Void> batchDelete(@RequestBody List<Integer> ids) {
        return readerProposalService.batchDelete(ids);
    }

    /**
     * 读者建议修改
     *
     * @param readerProposal 参数
     * @return Result<Void> 响应
     */
    @PutMapping(value = "/update")
    public Result<Void> update(@RequestBody ReaderProposal readerProposal) {
        return readerProposalService.update(readerProposal);
    }

    /**
     * 读者建议查询
     *
     * @param readerProposalQueryDto 查询参数
     * @return Result<List < ReadingProposalVO>> 通用响应
     */
    @Pager
    @PostMapping(value = "/query")
    public Result<List<ReaderProposalVO>> query(@RequestBody ReaderProposalQueryDto readerProposalQueryDto) {
        return readerProposalService.query(readerProposalQueryDto);
    }

    /**
     * 查询用户自己发布的读者建议
     *
     * @param readerProposalQueryDto 查询参数
     * @return Result<List < ReadingProposalVO>> 通用响应
     */
    @Pager
    @PostMapping(value = "/queryUser")
    public Result<List<ReaderProposalVO>> queryUser(@RequestBody ReaderProposalQueryDto readerProposalQueryDto) {
        readerProposalQueryDto.setUserId(LocalThreadHolder.getUserId());
        return readerProposalService.query(readerProposalQueryDto);
    }

}
