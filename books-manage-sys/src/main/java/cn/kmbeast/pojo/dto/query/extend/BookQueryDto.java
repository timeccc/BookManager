package cn.kmbeast.pojo.dto.query.extend;

import cn.kmbeast.pojo.dto.query.base.QueryDto;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 书籍的查询条件类
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class BookQueryDto extends QueryDto {
    /**
     * 书籍名
     */
    private String name;
    /**
     * 出版商
     */
    private String publisher;
    /**
     * 图书类别ID
     */
    private Integer categoryId;
    /**
     * 是否为预售书籍
     */
    private Boolean isPlanBuy;
    /**
     * 用户ID
     */
    private Integer userId;

}
