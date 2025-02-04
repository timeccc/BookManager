package cn.kmbeast.service;

import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.vo.ChartVO;

import java.util.List;

public interface ViewsService {

    Result<List<ChartVO>> staticControls();

}
