package cn.kmbeast.service.impl;

import cn.kmbeast.context.LocalThreadHolder;
import cn.kmbeast.mapper.ReaderProposalMapper;
import cn.kmbeast.mapper.UserMapper;
import cn.kmbeast.pojo.api.ApiResult;
import cn.kmbeast.pojo.api.PageResult;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.ReaderProposalQueryDto;
import cn.kmbeast.pojo.dto.query.extend.UserQueryDto;
import cn.kmbeast.pojo.entity.ReaderProposal;
import cn.kmbeast.pojo.entity.User;
import cn.kmbeast.pojo.vo.ReaderProposalVO;
import cn.kmbeast.service.ReaderProposalService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 读者建议业务逻辑实现
 */
@Service
public class ReaderProposalServiceImpl implements ReaderProposalService {

    @Resource
    private ReaderProposalMapper readerProposalMapper;
    @Resource
    private UserMapper userMapper;

    /**
     * 读者建议新增
     *
     * @param readerProposal 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> save(ReaderProposal readerProposal) {
        // 如果用户已经被禁言，不能留言
        UserQueryDto userQueryDto = new UserQueryDto();
        userQueryDto.setId(LocalThreadHolder.getUserId());
        List<User> userList = userMapper.query(userQueryDto);
        User user = userList.get(0);
        if (user.getIsWord()) {
            return ApiResult.error("账号已被禁言，请联系管理员");
        }
        readerProposal.setUserId(LocalThreadHolder.getUserId());
        readerProposal.setIsReply(false);
        readerProposal.setCreateTime(LocalDateTime.now());
        readerProposalMapper.save(readerProposal);
        return ApiResult.success();
    }

    /**
     * 读者建议删除
     *
     * @param ids 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> batchDelete(List<Integer> ids) {
        readerProposalMapper.batchDelete(ids);
        return ApiResult.success();
    }

    /**
     * 读者建议修改
     *
     * @param readerProposal 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> update(ReaderProposal readerProposal) {
        // 证明管理员回复
        if (readerProposal.getReplyContent() != null) {
            readerProposal.setReplyTime(LocalDateTime.now());
        }
        readerProposal.setIsReply(true);
        readerProposalMapper.update(readerProposal);
        return ApiResult.success();
    }

    /**
     * 读者建议查询
     *
     * @param readerProposalQueryDto 查询参数
     * @return Result<List < ReadingProposalVO>>
     */
    @Override
    public Result<List<ReaderProposalVO>> query(ReaderProposalQueryDto readerProposalQueryDto) {
        List<ReaderProposalVO> noticeList = readerProposalMapper.query(readerProposalQueryDto);
        Integer totalCount = readerProposalMapper.queryCount(readerProposalQueryDto);
        return PageResult.success(noticeList, totalCount);
    }
}
