package cn.kmbeast.pojo.vo;

import cn.kmbeast.pojo.entity.Book;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class BookVO extends Book {
    /**
     * 类别名
     */
    private String categoryName;
    /**
     * 楼层
     */
    private String floor;
    /**
     * 区域
     */
    private String area;
    /**
     * 书架名
     */
    private String frame;
    /**
     * 是否已经收藏该书籍
     */
    private Boolean isSave;
    /**
     * 是否已经订阅该书籍
     */
    private Boolean isRss;
    /**
     * 是否已经借书并且未归还
     */
    private Boolean isReturn;

}
