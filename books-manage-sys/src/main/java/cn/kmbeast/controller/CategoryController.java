package cn.kmbeast.controller;

import cn.kmbeast.aop.Pager;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.CategoryQueryDto;
import cn.kmbeast.pojo.entity.Category;
import cn.kmbeast.service.CategoryService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * 书籍类别的 Controller
 */
@RestController
@RequestMapping(value = "/category")
public class CategoryController {

    @Resource
    private CategoryService categoryService;

    /**
     * 书籍类别新增
     *
     * @param category 新增数据
     * @return Result<Void> 通用响应体
     */
    @PostMapping(value = "/save")
    public Result<Void> save(@RequestBody Category category) {
        return categoryService.save(category);
    }

    /**
     * 书籍类别删除
     *
     * @param ids 要删除的书籍类别ID列表
     * @return Result<Void> 通用响应体
     */
    @PostMapping(value = "/batchDelete")
    public Result<Void> batchDelete(@RequestBody List<Integer> ids) {
        return categoryService.batchDelete(ids);
    }

    /**
     * 书籍类别修改
     *
     * @param category 参数
     * @return Result<Void> 响应
     */
    @PutMapping(value = "/update")
    public Result<Void> update(@RequestBody Category category) {
        return categoryService.update(category);
    }

    /**
     * 书籍类别查询
     *
     * @param categoryQueryDto 查询参数
     * @return Result<List < Category>> 通用响应
     */
    @Pager
    @PostMapping(value = "/query")
    public Result<List<Category>> query(@RequestBody CategoryQueryDto categoryQueryDto) {
        return categoryService.query(categoryQueryDto);
    }

}
