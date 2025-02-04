package cn.kmbeast.pojo.entity;

import lombok.Data;

/**
 * 书籍收藏实体
 */
@Data
public class BookSave {
    /**
     * 主键
     */
    private Integer id;
    /**
     * 书籍ID
     */
    private Integer bookId;
    /**
     * 用户ID
     */
    private Integer userId;
}
