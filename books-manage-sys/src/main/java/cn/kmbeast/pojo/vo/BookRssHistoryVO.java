package cn.kmbeast.pojo.vo;

import cn.kmbeast.pojo.entity.BookOrderHistory;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class BookRssHistoryVO extends BookOrderHistory {
    /**
     * 书籍名
     */
    private String bookName;
    /**
     * 书籍作者
     */
    private String author;
    /**
     * 书籍馆藏量
     */
    private Integer num;
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
     * 用户名
     */
    private String userName;
}
