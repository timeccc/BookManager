package cn.kmbeast.service;

import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.CategoryQueryDto;
import cn.kmbeast.pojo.entity.Category;

import java.util.List;

/**
 * 书籍种类业务逻辑接口
 */
public interface CategoryService {

    Result<Void> save(Category category);

    Result<Void> batchDelete(List<Integer> ids);

    Result<Void> update(Category category);

    Result<List<Category>> query(CategoryQueryDto categoryQueryDto);

}
