package cn.kmbeast.mapper;

import cn.kmbeast.pojo.dto.query.extend.CategoryQueryDto;
import cn.kmbeast.pojo.entity.Category;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 书籍类别持久化接口
 */
@Mapper
public interface CategoryMapper {

    void save(Category category);

    void update(Category category);

    void batchDelete(@Param(value = "ids") List<Integer> ids);

    List<Category> query(CategoryQueryDto categoryQueryDto);

    Integer queryCount(CategoryQueryDto categoryQueryDto);

}
