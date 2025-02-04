package cn.kmbeast.pojo.entity;

import lombok.Data;

/**
 * 书籍类别实体类
 */
@Data
public class Category {
    /**
     * 主键
     */
    private Integer id;
    /**
     * 类别名
     */
    private String name;
}
