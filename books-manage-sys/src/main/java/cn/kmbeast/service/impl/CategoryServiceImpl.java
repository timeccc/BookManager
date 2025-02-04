package cn.kmbeast.service.impl;

import cn.kmbeast.mapper.CategoryMapper;
import cn.kmbeast.pojo.api.ApiResult;
import cn.kmbeast.pojo.api.PageResult;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.CategoryQueryDto;
import cn.kmbeast.pojo.entity.Category;
import cn.kmbeast.service.CategoryService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * 书籍类别业务逻辑实现
 */
@Service
public class CategoryServiceImpl implements CategoryService {

    @Resource
    private CategoryMapper categoryMapper;

    /**
     * 书籍类别新增
     *
     * @param category 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> save(Category category) {
        categoryMapper.save(category);
        return ApiResult.success();
    }

    /**
     * 书籍类别删除
     *
     * @param ids 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> batchDelete(List<Integer> ids) {
        categoryMapper.batchDelete(ids);
        return ApiResult.success();
    }

    /**
     * 书籍类别修改
     *
     * @param category 参数
     * @return Result<Void>
     */
    @Override
    public Result<Void> update(Category category) {
        categoryMapper.update(category);
        return ApiResult.success();
    }

    /**
     * 书籍类别查询
     *
     * @param categoryQueryDto 查询参数
     * @return Result<List < Category>>
     */
    @Override
    public Result<List<Category>> query(CategoryQueryDto categoryQueryDto) {
        List<Category> noticeList = categoryMapper.query(categoryQueryDto);
        Integer totalCount = categoryMapper.queryCount(categoryQueryDto);
        return PageResult.success(noticeList, totalCount);
    }


}
