package cn.kmbeast.service;

import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.ReaderProposalQueryDto;
import cn.kmbeast.pojo.entity.ReaderProposal;
import cn.kmbeast.pojo.vo.ReaderProposalVO;

import java.util.List;

/**
 * 读者建议的业务逻辑接口
 */
public interface ReaderProposalService {

    Result<Void> save(ReaderProposal readerProposal);

    Result<Void> batchDelete(List<Integer> ids);

    Result<Void> update(ReaderProposal readerProposal);

    Result<List<ReaderProposalVO>> query(ReaderProposalQueryDto readerProposalQueryDto);

}
